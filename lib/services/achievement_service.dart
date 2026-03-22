import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';

class AchievementService {
  static const String _key = 'achievements';
  static const String _keyStats = 'achievement_stats';

  /// 加载成就列表（带解锁状态）
  static Future<List<Achievement>> loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_key);

    if (saved == null) {
      return Achievement.defaultAchievements;
    }

    final Map<String, dynamic> decoded = jsonDecode(saved);
    return Achievement.defaultAchievements.map((template) {
      final data = decoded[template.id];
      if (data != null) {
        return Achievement.fromJson(data as Map<String, dynamic>, template);
      }
      return template;
    }).toList();
  }

  /// 保存成就状态
  static Future<void> saveAchievements(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> data = {};

    for (final a in achievements) {
      data[a.id] = a.toJson();
    }

    await prefs.setString(_key, jsonEncode(data));
  }

  /// 解锁成就
  static Future<Achievement?> unlockAchievement(
    List<Achievement> achievements,
    String achievementId,
  ) async {
    final index = achievements.indexWhere((a) => a.id == achievementId);
    if (index == -1) return null;

    final achievement = achievements[index];
    if (achievement.isUnlocked) return null;

    final unlocked = achievement.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );

    achievements[index] = unlocked;
    await saveAchievements(achievements);

    return unlocked;
  }

  /// 检查并更新基于统计的成就
  static Future<List<Achievement>> checkStatAchievements(
    List<Achievement> achievements, {
    required int totalFlags,
    required int totalFails,
    required int totalPardons,
    required int totalExecutions,
    required int consecutiveNoFail,
  }) async {
    final newlyUnlocked = <Achievement>[];

    final checks = {
      'first_flag': totalFlags >= 1,
      'flag_collector': totalFlags >= 10,
      'flag_factory': totalFlags >= 50,
      'pigeon_master': totalFails >= 10,
      'pigeon_god': totalFails >= 50,
      'survivor': totalPardons >= 1,
      'executed': totalExecutions >= 10,
      'no_excuses': consecutiveNoFail >= 3,
    };

    for (final entry in checks.entries) {
      if (entry.value) {
        final unlocked = await unlockAchievement(achievements, entry.key);
        if (unlocked != null) {
          newlyUnlocked.add(unlocked);
        }
      }
    }

    return newlyUnlocked;
  }

  /// 加载统计数据
  static Future<Map<String, int>> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_keyStats);

    if (saved == null) {
      return {
        'totalFlags': 0,
        'totalFails': 0,
        'totalPardons': 0,
        'totalExecutions': 0,
        'consecutiveNoFail': 0,
      };
    }

    return Map<String, int>.from(jsonDecode(saved));
  }

  /// 保存统计数据
  static Future<void> saveStats(Map<String, int> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStats, jsonEncode(stats));
  }

  /// 更新统计
  static Future<Map<String, int>> updateStats({
    int? flagsAdded,
    int? failsAdded,
    int? pardonsAdded,
    int? executionsAdded,
    bool? resetConsecutive,
  }) async {
    final stats = await loadStats();

    if (flagsAdded != null)
      stats['totalFlags'] = (stats['totalFlags'] ?? 0) + flagsAdded;
    if (failsAdded != null) {
      stats['totalFails'] = (stats['totalFails'] ?? 0) + failsAdded;
      stats['consecutiveNoFail'] = 0; // 鸽了就重置
    }
    if (pardonsAdded != null)
      stats['totalPardons'] = (stats['totalPardons'] ?? 0) + pardonsAdded;
    if (executionsAdded != null)
      stats['totalExecutions'] =
          (stats['totalExecutions'] ?? 0) + executionsAdded;
    if (resetConsecutive == true)
      stats['consecutiveNoFail'] = (stats['consecutiveNoFail'] ?? 0) + 1;

    await saveStats(stats);
    return stats;
  }
}
