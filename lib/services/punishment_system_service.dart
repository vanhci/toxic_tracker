import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 惩罚等级（升级版）
enum PunishmentTier {
  none,       // 无惩罚
  tier1,      // Lv1: 毒舌提醒（弹窗+推送）
  tier2,      // Lv2: 强制锁屏（5分钟不可用手机）
  tier3,      // Lv3: 公开处刑（分享到朋友圈/群）
  tier4,      // Lv4: 金钱惩罚（微信/支付宝扣款）
  tier5,      // Lv5: 账号惩罚（功能限制）
}

/// 惩罚行为
class PunishmentAction {
  final String id;
  final String name;
  final String description;
  final PunishmentTier tier;
  final int durationSeconds;
  final bool isEnabled;
  final int unlockLevel; // 解锁所需等级（累计惩罚次数）

  const PunishmentAction({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    this.durationSeconds = 0,
    this.isEnabled = true,
    this.unlockLevel = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'tier': tier.index,
    'durationSeconds': durationSeconds,
    'isEnabled': isEnabled,
    'unlockLevel': unlockLevel,
  };

  factory PunishmentAction.fromJson(Map<String, dynamic> json) {
    return PunishmentAction(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      tier: PunishmentTier.values[json['tier'] ?? 1],
      durationSeconds: json['durationSeconds'] ?? 0,
      isEnabled: json['isEnabled'] ?? true,
      unlockLevel: json['unlockLevel'] ?? 0,
    );
  }

  /// 默认惩罚行为列表
  static List<PunishmentAction> get defaultActions => [
    // Lv1: 毒舌提醒
    const PunishmentAction(
      id: 'verbal_warning',
      name: '毒舌弹窗',
      description: '弹窗显示毒舌提醒',
      tier: PunishmentTier.tier1,
      isEnabled: true,
    ),
    const PunishmentAction(
      id: 'push_notification',
      name: '毒舌推送',
      description: '推送毒舌通知',
      tier: PunishmentTier.tier1,
      isEnabled: true,
    ),
    const PunishmentAction(
      id: 'annoying_popup',
      name: '弹窗骚扰',
      description: '连续弹出毒舌弹窗',
      tier: PunishmentTier.tier1,
      durationSeconds: 60,
      isEnabled: true,
    ),
    // Lv2: 强制锁屏
    const PunishmentAction(
      id: 'screen_lock',
      name: '强制锁屏',
      description: '强制锁屏5分钟',
      tier: PunishmentTier.tier2,
      durationSeconds: 300,
      isEnabled: true,
    ),
    const PunishmentAction(
      id: 'screen_flash',
      name: '屏幕闪烁',
      description: '屏幕闪烁警告',
      tier: PunishmentTier.tier2,
      durationSeconds: 30,
      isEnabled: true,
    ),
    const PunishmentAction(
      id: 'screen_crack',
      name: '屏幕裂纹',
      description: '显示裂纹效果',
      tier: PunishmentTier.tier2,
      durationSeconds: 60,
      isEnabled: false,
    ),
    // Lv3: 公开处刑
    const PunishmentAction(
      id: 'shame_poster',
      name: '耻辱证书',
      description: '生成耻辱证书海报',
      tier: PunishmentTier.tier3,
      isEnabled: true,
    ),
    const PunishmentAction(
      id: 'shame_share',
      name: '公开处刑',
      description: '分享到朋友圈/群',
      tier: PunishmentTier.tier3,
      isEnabled: false,
    ),
    const PunishmentAction(
      id: 'shame_certificate',
      name: '处刑令',
      description: '自动发送处刑令给死党',
      tier: PunishmentTier.tier3,
      isEnabled: false,
    ),
    // Lv4: 金钱惩罚
    const PunishmentAction(
      id: 'wechat_pay',
      name: '微信扣款',
      description: '微信支付小额罚款',
      tier: PunishmentTier.tier4,
      isEnabled: false,
      unlockLevel: 10,
    ),
    const PunishmentAction(
      id: 'alipay_pay',
      name: '支付宝扣款',
      description: '支付宝小额罚款',
      tier: PunishmentTier.tier4,
      isEnabled: false,
      unlockLevel: 10,
    ),
    // Lv5: 账号惩罚
    const PunishmentAction(
      id: 'feature_limit',
      name: '功能限制',
      description: '限制部分功能使用',
      tier: PunishmentTier.tier5,
      isEnabled: true,
      unlockLevel: 15,
    ),
    const PunishmentAction(
      id: 'avatar_shame',
      name: '头像惩罚',
      description: '临时修改头像为耻辱图片',
      tier: PunishmentTier.tier5,
      durationSeconds: 86400,
      isEnabled: false,
      unlockLevel: 20,
    ),
  ];
}

/// 惩罚执行记录
class PunishmentExecution {
  final String id;
  final String actionId;
  final String taskTitle;
  final int failCount;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;
  final String? coachName;
  final String? shameText;

  PunishmentExecution({
    required this.id,
    required this.actionId,
    required this.taskTitle,
    required this.failCount,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.coachName,
    this.shameText,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'actionId': actionId,
    'taskTitle': taskTitle,
    'failCount': failCount,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'isCompleted': isCompleted,
    'coachName': coachName,
    'shameText': shameText,
  };

  factory PunishmentExecution.fromJson(Map<String, dynamic> json) {
    return PunishmentExecution(
      id: json['id'],
      actionId: json['actionId'],
      taskTitle: json['taskTitle'],
      failCount: json['failCount'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      isCompleted: json['isCompleted'] ?? false,
      coachName: json['coachName'],
      shameText: json['shameText'],
    );
  }
}

/// 惩罚仪表盘数据
class PunishmentDashboard {
  final int totalPunishments;
  final int currentLevel;
  final PunishmentTier currentTier;
  final int punishmentsThisWeek;
  final int punishmentsThisMonth;
  final List<PunishmentAction> unlockedActions;
  final List<PunishmentExecution> recentExecutions;
  final Map<String, int> actionStats;

  const PunishmentDashboard({
    this.totalPunishments = 0,
    this.currentLevel = 1,
    this.currentTier = PunishmentTier.none,
    this.punishmentsThisWeek = 0,
    this.punishmentsThisMonth = 0,
    this.unlockedActions = const [],
    this.recentExecutions = const [],
    this.actionStats = const {},
  });
}

/// 惩罚系统服务（升级版）
class PunishmentSystemService {
  static const String _actionsKey = 'punishment_actions';
  static const String _executionsKey = 'punishment_executions';
  static const String _statsKey = 'punishment_stats';

  /// 根据累计惩罚次数计算用户等级
  static int calculateUserLevel(int totalPunishments) {
    if (totalPunishments < 5) return 1;
    if (totalPunishments < 10) return 2;
    if (totalPunishments < 20) return 3;
    if (totalPunishments < 35) return 4;
    if (totalPunishments < 50) return 5;
    if (totalPunishments < 75) return 6;
    if (totalPunishments < 100) return 7;
    return 8;
  }

  /// 根据连续失败次数获取惩罚等级
  static PunishmentTier getTier(int consecutiveFails) {
    if (consecutiveFails <= 0) return PunishmentTier.none;
    if (consecutiveFails <= 2) return PunishmentTier.tier1;
    if (consecutiveFails <= 5) return PunishmentTier.tier2;
    if (consecutiveFails <= 10) return PunishmentTier.tier3;
    if (consecutiveFails <= 20) return PunishmentTier.tier4;
    return PunishmentTier.tier5;
  }

  /// 获取等级描述
  static String getTierDescription(PunishmentTier tier) {
    switch (tier) {
      case PunishmentTier.none:
        return '清白';
      case PunishmentTier.tier1:
        return 'Lv1 毒舌提醒';
      case PunishmentTier.tier2:
        return 'Lv2 强制锁屏';
      case PunishmentTier.tier3:
        return 'Lv3 公开处刑';
      case PunishmentTier.tier4:
        return 'Lv4 金钱惩罚';
      case PunishmentTier.tier5:
        return 'Lv5 账号惩罚';
    }
  }

  /// 获取等级图标
  static String getTierEmoji(PunishmentTier tier) {
    switch (tier) {
      case PunishmentTier.none:
        return '😇';
      case PunishmentTier.tier1:
        return '⚠️';
      case PunishmentTier.tier2:
        return '🔒';
      case PunishmentTier.tier3:
        return '📢';
      case PunishmentTier.tier4:
        return '💰';
      case PunishmentTier.tier5:
        return '☠️';
    }
  }

  /// 获取等级颜色（十六进制）
  static String getTierColor(PunishmentTier tier) {
    switch (tier) {
      case PunishmentTier.none:
        return '#4CAF50';
      case PunishmentTier.tier1:
        return '#FFC107';
      case PunishmentTier.tier2:
        return '#FF9800';
      case PunishmentTier.tier3:
        return '#F44336';
      case PunishmentTier.tier4:
        return '#9C27B0';
      case PunishmentTier.tier5:
        return '#000000';
    }
  }

  /// 根据等级获取可用的惩罚行为
  static List<PunishmentAction> getAvailableActions(
    PunishmentTier tier,
    int userLevel, {
    List<PunishmentAction>? customActions,
  }) {
    final actions = customActions ?? PunishmentAction.defaultActions;
    return actions.where((action) {
      if (action.tier.index > tier.index) return false;
      if (action.unlockLevel > userLevel) return false;
      return action.isEnabled;
    }).toList();
  }

  /// 执行惩罚
  static Future<PunishmentExecution> executePunishment({
    required String actionId,
    required String taskTitle,
    required int failCount,
    String? coachName,
    String? shameText,
  }) async {
    final execution = PunishmentExecution(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      actionId: actionId,
      taskTitle: taskTitle,
      failCount: failCount,
      startTime: DateTime.now(),
      coachName: coachName,
      shameText: shameText,
    );

    await _saveExecution(execution);
    await _updateStats(actionId);
    return execution;
  }

  /// 完成惩罚
  static Future<void> completePunishment(String executionId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_executionsKey);
    if (jsonStr == null) return;

    final List<dynamic> executions = jsonDecode(jsonStr);
    for (var e in executions) {
      if (e['id'] == executionId) {
        e['isCompleted'] = true;
        e['endTime'] = DateTime.now().toIso8601String();
        break;
      }
    }
    await prefs.setString(_executionsKey, jsonEncode(executions));
  }

  /// 获取惩罚历史
  static Future<List<PunishmentExecution>> getExecutionHistory({
    int limit = 50,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_executionsKey);
    if (jsonStr == null) return [];

    final List<dynamic> executions = jsonDecode(jsonStr);
    return executions
        .map((e) => PunishmentExecution.fromJson(e))
        .take(limit)
        .toList();
  }

  /// 获取惩罚仪表盘数据
  static Future<PunishmentDashboard> getDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    final stats = statsJson != null 
        ? Map<String, int>.from(jsonDecode(statsJson))
        : <String, int>{};

    final totalPunishments = stats['total'] ?? 0;
    final punishmentsThisWeek = stats['thisWeek'] ?? 0;
    final punishmentsThisMonth = stats['thisMonth'] ?? 0;
    final currentLevel = calculateUserLevel(totalPunishments);
    final currentTier = getTier(stats['consecutiveFails'] ?? 0);

    final allActions = await loadActions();
    final unlockedActions = allActions
        .where((a) => a.unlockLevel <= currentLevel)
        .toList();

    final recentExecutions = await getExecutionHistory(limit: 10);

    return PunishmentDashboard(
      totalPunishments: totalPunishments,
      currentLevel: currentLevel,
      currentTier: currentTier,
      punishmentsThisWeek: punishmentsThisWeek,
      punishmentsThisMonth: punishmentsThisMonth,
      unlockedActions: unlockedActions,
      recentExecutions: recentExecutions,
      actionStats: stats,
    );
  }

  /// 加载惩罚行为配置
  static Future<List<PunishmentAction>> loadActions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_actionsKey);
    if (jsonStr == null) return PunishmentAction.defaultActions;

    final List<dynamic> actions = jsonDecode(jsonStr);
    return actions.map((a) => PunishmentAction.fromJson(a)).toList();
  }

  /// 保存惩罚行为配置
  static Future<void> saveActions(List<PunishmentAction> actions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_actionsKey, jsonEncode(actions.map((a) => a.toJson()).toList()));
  }

  /// 更新行为启用状态
  static Future<void> toggleAction(String actionId, bool enabled) async {
    final actions = await loadActions();
    final index = actions.indexWhere((a) => a.id == actionId);
    if (index != -1) {
      actions[index] = PunishmentAction(
        id: actions[index].id,
        name: actions[index].name,
        description: actions[index].description,
        tier: actions[index].tier,
        durationSeconds: actions[index].durationSeconds,
        isEnabled: enabled,
        unlockLevel: actions[index].unlockLevel,
      );
      await saveActions(actions);
    }
  }

  static Future<void> _saveExecution(PunishmentExecution execution) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_executionsKey);
    List<dynamic> executions = jsonStr != null ? jsonDecode(jsonStr) : [];
    
    executions.insert(0, execution.toJson());
    if (executions.length > 100) {
      executions = executions.sublist(0, 100);
    }
    await prefs.setString(_executionsKey, jsonEncode(executions));
  }

  static Future<void> _updateStats(String actionId) async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    final stats = statsJson != null 
        ? Map<String, int>.from(jsonDecode(statsJson))
        : <String, int>{};

    stats['total'] = (stats['total'] ?? 0) + 1;

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final lastWeekUpdate = prefs.getString('$_statsKey.weekUpdate');
    if (lastWeekUpdate == null || 
        DateTime.parse(lastWeekUpdate).isBefore(weekStart)) {
      stats['thisWeek'] = 1;
      await prefs.setString('$_statsKey.weekUpdate', now.toIso8601String());
    } else {
      stats['thisWeek'] = (stats['thisWeek'] ?? 0) + 1;
    }

    final monthStart = DateTime(now.year, now.month, 1);
    final lastMonthUpdate = prefs.getString('$_statsKey.monthUpdate');
    if (lastMonthUpdate == null || 
        DateTime.parse(lastMonthUpdate).isBefore(monthStart)) {
      stats['thisMonth'] = 1;
      await prefs.setString('$_statsKey.monthUpdate', now.toIso8601String());
    } else {
      stats['thisMonth'] = (stats['thisMonth'] ?? 0) + 1;
    }

    stats[actionId] = (stats[actionId] ?? 0) + 1;
    await prefs.setString(_statsKey, jsonEncode(stats));
  }

  /// 清除所有数据
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_actionsKey);
    await prefs.remove(_executionsKey);
    await prefs.remove(_statsKey);
  }
}
