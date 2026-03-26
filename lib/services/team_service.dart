import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/team.dart';
import 'task_storage.dart';

/// 团队服务 - 管理团队相关操作
class TeamService {
  static final _supabase = Supabase.instance.client;
  static const String _teamIdKey = 'current_team_id';

  /// 创建团队
  static Future<Team?> createTeam({
    required String name,
    required String leaderId,
    String? leaderName,
  }) async {
    try {
      // 生成邀请码（异步）
      final inviteCode = await _generateInviteCode();

      // 插入团队记录
      final response = await _supabase
          .from('teams')
          .insert({
            'name': name,
            'leader_id': leaderId,
            'invite_code': inviteCode,
            'settings': {
              'enable_notifications': true,
              'require_photo_proof': true,
              'fail_threshold': 3,
            },
          })
          .select()
          .single();

      final team = Team.fromJson(response);

      // 创建者自动加入团队
      await _supabase.from('team_members').insert({
        'team_id': team.id,
        'user_id': leaderId,
        'display_name': leaderName ?? '团队创建者',
        'role': 'admin',
      });

      // 保存当前团队 ID
      await _saveCurrentTeamId(team.id);

      return team;
    } catch (e) {
      debugPrint('创建团队失败: $e');
      return null;
    }
  }

  /// 通过邀请码加入团队
  static Future<Team?> joinTeam({
    required String inviteCode,
    required String userId,
    String? displayName,
  }) async {
    try {
      // 查找团队
      final teamResponse = await _supabase
          .from('teams')
          .select()
          .eq('invite_code', inviteCode.toUpperCase())
          .single();

      if (teamResponse.isEmpty) {
        debugPrint('无效的邀请码');
        return null;
      }

      final team = Team.fromJson(teamResponse);

      // 检查是否已加入
      final existingMember = await _supabase
          .from('team_members')
          .select()
          .eq('team_id', team.id)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingMember != null) {
        debugPrint('已经在团队中');
        await _saveCurrentTeamId(team.id);
        return team;
      }

      // 加入团队
      await _supabase.from('team_members').insert({
        'team_id': team.id,
        'user_id': userId,
        'display_name': displayName ?? '新成员',
        'role': 'member',
      });

      await _saveCurrentTeamId(team.id);
      return team;
    } catch (e) {
      debugPrint('加入团队失败: $e');
      return null;
    }
  }

  /// 获取团队信息
  static Future<Team?> getTeam(String teamId) async {
    try {
      final response = await _supabase.from('teams').select('''
            *,
            members:team_members(
              user_id,
              display_name,
              role,
              joined_at
            )
          ''').eq('id', teamId).single();

      return Team.fromJson(response);
    } catch (e) {
      debugPrint('获取团队失败: $e');
      return null;
    }
  }

  /// 获取当前用户的团队
  static Future<Team?> getCurrentTeam() async {
    try {
      final teamId = await _getCurrentTeamId();
      if (teamId == null) return null;

      return await getTeam(teamId);
    } catch (e) {
      debugPrint('获取当前团队失败: $e');
      return null;
    }
  }

  /// 获取用户所在的所有团队
  static Future<List<Team>> getUserTeams(String userId) async {
    try {
      final response = await _supabase.from('team_members').select('''
            team_id,
            teams(
              id,
              name,
              leader_id,
              invite_code,
              settings,
              created_at
            )
          ''').eq('user_id', userId);

      return response.map<Team>((item) {
        final teamData = item['teams'] as Map<String, dynamic>;
        return Team.fromJson(teamData);
      }).toList();
    } catch (e) {
      debugPrint('获取用户团队失败: $e');
      return [];
    }
  }

  /// 获取团队成员统计
  static Future<List<TeamMember>> getMemberStats(String teamId) async {
    try {
      final response = await _supabase.from('team_members').select('''
            user_id,
            display_name,
            role,
            joined_at
          ''').eq('team_id', teamId);

      // 获取本地任务统计（仅限当前用户）
      final storage = TaskStorage();
      final tasks = await storage.loadTasks();
      final totalTasks = tasks.length;
      final completedTasks = tasks.where((t) => !t.isOverdue).length;
      final totalFails =
          tasks.fold<int>(0, (sum, t) => sum + t.consecutiveFails);

      return response.map<TeamMember>((item) {
        final member = TeamMember.fromJson(item);
        // 当前用户才有本地统计
        return member.copyWith(
          totalTasks: totalTasks,
          completedTasks: completedTasks,
          totalFails: totalFails,
        );
      }).toList();
    } catch (e) {
      debugPrint('获取成员统计失败: $e');
      return [];
    }
  }

  /// 更新团队设置
  static Future<bool> updateTeamSettings({
    required String teamId,
    required TeamSettings settings,
  }) async {
    try {
      await _supabase
          .from('teams')
          .update({'settings': settings.toJson()}).eq('id', teamId);
      return true;
    } catch (e) {
      debugPrint('更新团队设置失败: $e');
      return false;
    }
  }

  /// 移除成员
  static Future<bool> removeMember({
    required String teamId,
    required String userId,
  }) async {
    try {
      await _supabase
          .from('team_members')
          .delete()
          .eq('team_id', teamId)
          .eq('user_id', userId);
      return true;
    } catch (e) {
      debugPrint('移除成员失败: $e');
      return false;
    }
  }

  /// 退出团队
  static Future<bool> leaveTeam({
    required String teamId,
    required String userId,
  }) async {
    try {
      await _supabase
          .from('team_members')
          .delete()
          .eq('team_id', teamId)
          .eq('user_id', userId);

      // 清除当前团队 ID
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_teamIdKey);

      return true;
    } catch (e) {
      debugPrint('退出团队失败: $e');
      return false;
    }
  }

  /// 生成邀请码 - 使用安全的随机算法 + 唯一性校验
  static Future<String> _generateInviteCode() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    
    // 最多尝试10次生成唯一邀请码
    for (var attempt = 0; attempt < 10; attempt++) {
      final code = StringBuffer();
      for (var i = 0; i < 6; i++) {
        code.write(chars[random.nextInt(chars.length)]);
      }
      final inviteCode = code.toString();
      
      // 检查唯一性
      final existing = await _supabase
          .from('teams')
          .select('id')
          .eq('invite_code', inviteCode)
          .maybeSingle();
      
      if (existing == null) {
        return inviteCode;
      }
    }
    
    // 如果10次都重复，使用UUID后6位作为后备方案
    final uuid = DateTime.now().microsecondsSinceEpoch.toString();
    return uuid.substring(uuid.length - 6).toUpperCase();
  }

  /// 保存当前团队 ID
  static Future<void> _saveCurrentTeamId(String teamId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_teamIdKey, teamId);
  }

  /// 获取当前团队 ID
  static Future<String?> _getCurrentTeamId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_teamIdKey);
  }

  /// 判断用户是否在团队中
  static Future<bool> isInTeam(String userId) async {
    try {
      final response = await _supabase
          .from('team_members')
          .select('team_id')
          .eq('user_id', userId)
          .limit(1);

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
