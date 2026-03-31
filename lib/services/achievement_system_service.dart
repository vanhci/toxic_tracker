import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 成就类型
enum AchievementCategory {
  basic,      // 基础成就
  challenge,  // 挑战成就
  social,     // 社交成就
  special,    // 特殊成就
  secret,     // 隐藏成就
}

/// 成就稀有度
enum AchievementRarity {
  common,     // 普通
  rare,       // 稀有
  epic,       // 史诗
  legendary,  // 传说
}

/// 成就奖励类型
enum RewardType {
  voicePack,      // 语音包
  title,          // 称号
  avatarFrame,    // 头像框
  toxicTemplate,  // 毒舌模板
  coachSkin,      // 教练皮肤
  badge,          // 徽章
}

/// 成就奖励
class AchievementReward {
  final RewardType type;
  final String id;
  final String name;
  final String description;
  final String? assetPath;

  const AchievementReward({
    required this.type,
    required this.id,
    required this.name,
    required this.description,
    this.assetPath,
  });

  Map<String, dynamic> toJson() => {
    'type': type.index,
    'id': id,
    'name': name,
    'description': description,
    'assetPath': assetPath,
  };

  factory AchievementReward.fromJson(Map<String, dynamic> json) {
    return AchievementReward(
      type: RewardType.values[json['type'] ?? 0],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      assetPath: json['assetPath'],
    );
  }
}

/// 成就定义（升级版）
class AchievementDefinition {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final int requirement;
  final int points;
  final List<AchievementReward> rewards;
  final bool isSecret;
  final String? prerequisiteId;

  const AchievementDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    this.category = AchievementCategory.basic,
    this.rarity = AchievementRarity.common,
    required this.requirement,
    this.points = 10,
    this.rewards = const [],
    this.isSecret = false,
    this.prerequisiteId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'emoji': emoji,
    'category': category.index,
    'rarity': rarity.index,
    'requirement': requirement,
    'points': points,
    'rewards': rewards.map((r) => r.toJson()).toList(),
    'isSecret': isSecret,
    'prerequisiteId': prerequisiteId,
  };

  factory AchievementDefinition.fromJson(Map<String, dynamic> json) {
    return AchievementDefinition(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      emoji: json['emoji'],
      category: AchievementCategory.values[json['category'] ?? 0],
      rarity: AchievementRarity.values[json['rarity'] ?? 0],
      requirement: json['requirement'],
      points: json['points'] ?? 10,
      rewards: (json['rewards'] as List?)
          ?.map((r) => AchievementReward.fromJson(r))
          .toList() ?? [],
      isSecret: json['isSecret'] ?? false,
      prerequisiteId: json['prerequisiteId'],
    );
  }

  /// 所有成就定义
  static List<AchievementDefinition> get allAchievements => [
    // ==================== 基础成就 ====================
    const AchievementDefinition(
      id: 'first_flag',
      title: '立Flag新手',
      description: '立下第一个Flag',
      emoji: '🚩',
      category: AchievementCategory.basic,
      rarity: AchievementRarity.common,
      requirement: 1,
      points: 5,
    ),
    const AchievementDefinition(
      id: 'flag_collector',
      title: 'Flag收割机',
      description: '累计立下10个Flag',
      emoji: '🏳️',
      category: AchievementCategory.basic,
      rarity: AchievementRarity.common,
      requirement: 10,
      points: 10,
    ),
    const AchievementDefinition(
      id: 'flag_factory',
      title: 'Flag制造厂',
      description: '累计立下50个Flag',
      emoji: '🏭',
      category: AchievementCategory.basic,
      rarity: AchievementRarity.rare,
      requirement: 50,
      points: 30,
      rewards: [
        AchievementReward(
          type: RewardType.title,
          id: 'flag_master',
          name: 'Flag大师',
          description: '解锁专属称号',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'flag_empire',
      title: 'Flag帝国',
      description: '累计立下100个Flag',
      emoji: '🏰',
      category: AchievementCategory.basic,
      rarity: AchievementRarity.epic,
      requirement: 100,
      points: 50,
      rewards: [
        AchievementReward(
          type: RewardType.avatarFrame,
          id: 'flag_frame',
          name: 'Flag框架',
          description: '专属头像框',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'first_complete',
      title: '说到做到',
      description: '完成第一个Flag',
      emoji: '✅',
      category: AchievementCategory.basic,
      rarity: AchievementRarity.common,
      requirement: 1,
      points: 10,
    ),
    const AchievementDefinition(
      id: 'complete_10',
      title: '行动派',
      description: '累计完成10个Flag',
      emoji: '🎯',
      category: AchievementCategory.basic,
      rarity: AchievementRarity.common,
      requirement: 10,
      points: 20,
    ),
    const AchievementDefinition(
      id: 'complete_50',
      title: '执行力MAX',
      description: '累计完成50个Flag',
      emoji: '💪',
      category: AchievementCategory.basic,
      rarity: AchievementRarity.rare,
      requirement: 50,
      points: 40,
      rewards: [
        AchievementReward(
          type: RewardType.voicePack,
          id: 'cheerful_voice',
          name: '欢快语音包',
          description: '解锁欢快语音包',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'complete_100',
      title: '自律王者',
      description: '累计完成100个Flag',
      emoji: '👑',
      category: AchievementCategory.basic,
      rarity: AchievementRarity.legendary,
      requirement: 100,
      points: 100,
      rewards: [
        AchievementReward(
          type: RewardType.title,
          id: 'self_discipline_king',
          name: '自律王者',
          description: '传说称号',
        ),
        AchievementReward(
          type: RewardType.avatarFrame,
          id: 'crown_frame',
          name: '皇冠框架',
          description: '传说头像框',
        ),
      ],
    ),

    // ==================== 挑战成就 ====================
    const AchievementDefinition(
      id: 'no_fail_week',
      title: '一周不鸽',
      description: '连续7天完成所有Flag',
      emoji: '📅',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.rare,
      requirement: 7,
      points: 30,
    ),
    const AchievementDefinition(
      id: 'no_fail_month',
      title: '月度自律达人',
      description: '连续30天完成所有Flag',
      emoji: '🏆',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.epic,
      requirement: 30,
      points: 80,
      rewards: [
        AchievementReward(
          type: RewardType.badge,
          id: 'monthly_master',
          name: '月度达人徽章',
          description: '专属徽章',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'early_bird',
      title: '早起打卡',
      description: '连续7天早上8点前完成Flag',
      emoji: '🌅',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.rare,
      requirement: 7,
      points: 25,
    ),
    const AchievementDefinition(
      id: 'early_bird_30',
      title: '晨型人',
      description: '连续30天早上8点前完成Flag',
      emoji: '🌄',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.epic,
      requirement: 30,
      points: 60,
      rewards: [
        AchievementReward(
          type: RewardType.voicePack,
          id: 'morning_voice',
          name: '早安语音包',
          description: '专属语音',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'no_pigeon_month',
      title: '零逾期一个月',
      description: '一个月内零逾期',
      emoji: '🕊️',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.epic,
      requirement: 30,
      points: 100,
      rewards: [
        AchievementReward(
          type: RewardType.toxicTemplate,
          id: 'gentle_toxic',
          name: '温柔毒舌包',
          description: '解锁温柔风格毒舌',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'punished_10',
      title: '身经百刑',
      description: '累计接受惩罚10次',
      emoji: '💀',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.common,
      requirement: 10,
      points: 15,
    ),
    const AchievementDefinition(
      id: 'punished_50',
      title: '惩罚专业户',
      description: '累计接受惩罚50次',
      emoji: '🔥',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.rare,
      requirement: 50,
      points: 40,
    ),
    const AchievementDefinition(
      id: 'survivor',
      title: '劫后余生',
      description: '死党选择"算他过了"',
      emoji: '😮‍💨',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.common,
      requirement: 1,
      points: 10,
    ),
    const AchievementDefinition(
      id: 'consecutive_3',
      title: '从不找借口',
      description: '连续3个任务不鸽',
      emoji: '💪',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.common,
      requirement: 3,
      points: 15,
    ),
    const AchievementDefinition(
      id: 'consecutive_10',
      title: '守信之人',
      description: '连续10个任务不鸽',
      emoji: '🤝',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.rare,
      requirement: 10,
      points: 35,
    ),
    const AchievementDefinition(
      id: 'consecutive_50',
      title: '钢铁意志',
      description: '连续50个任务不鸽',
      emoji: '🔩',
      category: AchievementCategory.challenge,
      rarity: AchievementRarity.legendary,
      requirement: 50,
      points: 150,
      rewards: [
        AchievementReward(
          type: RewardType.title,
          id: 'iron_will',
          name: '钢铁意志',
          description: '传说称号',
        ),
      ],
    ),

    // ==================== 社交成就 ====================
    const AchievementDefinition(
      id: 'invite_friend',
      title: '广交好友',
      description: '邀请1个死党加入',
      emoji: '👥',
      category: AchievementCategory.social,
      rarity: AchievementRarity.common,
      requirement: 1,
      points: 15,
    ),
    const AchievementDefinition(
      id: 'invite_5',
      title: '社交达人',
      description: '邀请5个死党加入',
      emoji: '🎉',
      category: AchievementCategory.social,
      rarity: AchievementRarity.rare,
      requirement: 5,
      points: 40,
      rewards: [
        AchievementReward(
          type: RewardType.coachSkin,
          id: 'social_coach',
          name: '社交教练皮肤',
          description: '专属教练皮肤',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'invite_10',
      title: '朋友遍天下',
      description: '邀请10个死党加入',
      emoji: '🌍',
      category: AchievementCategory.social,
      rarity: AchievementRarity.epic,
      requirement: 10,
      points: 80,
      rewards: [
        AchievementReward(
          type: RewardType.title,
          id: 'social_king',
          name: '社交之王',
          description: '史诗称号',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'execute_10',
      title: '处刑官',
      description: '成功处刑10次',
      emoji: '⚔️',
      category: AchievementCategory.social,
      rarity: AchievementRarity.common,
      requirement: 10,
      points: 20,
    ),
    const AchievementDefinition(
      id: 'execute_50',
      title: '处刑大师',
      description: '成功处刑50次',
      emoji: '🗡️',
      category: AchievementCategory.social,
      rarity: AchievementRarity.rare,
      requirement: 50,
      points: 50,
    ),
    const AchievementDefinition(
      id: 'execute_100',
      title: '处刑之王',
      description: '成功处刑100次',
      emoji: '👑',
      category: AchievementCategory.social,
      rarity: AchievementRarity.epic,
      requirement: 100,
      points: 100,
      rewards: [
        AchievementReward(
          type: RewardType.badge,
          id: 'executioner',
          name: '处刑者徽章',
          description: '专属徽章',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'share_shame',
      title: '社死达人',
      description: '分享处刑证书10次',
      emoji: '📢',
      category: AchievementCategory.social,
      rarity: AchievementRarity.common,
      requirement: 10,
      points: 15,
    ),

    // ==================== 特殊成就 ====================
    const AchievementDefinition(
      id: 'weekend_warrior',
      title: '周末不鸽',
      description: '连续4个周末完成所有Flag',
      emoji: '🗓️',
      category: AchievementCategory.special,
      rarity: AchievementRarity.rare,
      requirement: 4,
      points: 40,
    ),
    const AchievementDefinition(
      id: 'holiday_hero',
      title: '节假日全勤',
      description: '在节假日完成所有Flag',
      emoji: '🎄',
      category: AchievementCategory.special,
      rarity: AchievementRarity.epic,
      requirement: 7,
      points: 60,
    ),
    const AchievementDefinition(
      id: 'midnight_owl',
      title: '夜猫子',
      description: '在凌晨完成任务10次',
      emoji: '🦉',
      category: AchievementCategory.special,
      rarity: AchievementRarity.rare,
      requirement: 10,
      points: 25,
    ),
    const AchievementDefinition(
      id: 'new_year_resolution',
      title: '新年决心',
      description: '在新年第一天完成Flag',
      emoji: '🎊',
      category: AchievementCategory.special,
      rarity: AchievementRarity.rare,
      requirement: 1,
      points: 30,
    ),
    const AchievementDefinition(
      id: 'valentine_single',
      title: '单身狗的坚持',
      description: '在情人节完成所有Flag',
      emoji: '💔',
      category: AchievementCategory.special,
      rarity: AchievementRarity.rare,
      requirement: 1,
      points: 25,
    ),
    const AchievementDefinition(
      id: 'monday_motivation',
      title: '周一动力',
      description: '连续5个周一完成所有Flag',
      emoji: '💪',
      category: AchievementCategory.special,
      rarity: AchievementRarity.rare,
      requirement: 5,
      points: 35,
    ),
    const AchievementDefinition(
      id: 'comeback_king',
      title: '东山再起',
      description: '在连续失败10次后重新连续完成5个Flag',
      emoji: '🔄',
      category: AchievementCategory.special,
      rarity: AchievementRarity.epic,
      requirement: 5,
      points: 50,
    ),

    // ==================== 隐藏成就 ====================
    const AchievementDefinition(
      id: 'pigeon_king',
      title: '鸽子之王',
      description: '累计鸽了100次',
      emoji: '🕊️',
      category: AchievementCategory.secret,
      rarity: AchievementRarity.legendary,
      requirement: 100,
      points: 100,
      isSecret: true,
      rewards: [
        AchievementReward(
          type: RewardType.title,
          id: 'pigeon_king',
          name: '鸽子之王',
          description: '隐藏称号',
        ),
      ],
    ),
    const AchievementDefinition(
      id: 'master_of_excuses',
      title: '借口大师',
      description: '累计使用30种不同的借口',
      emoji: '🎭',
      category: AchievementCategory.secret,
      rarity: AchievementRarity.epic,
      requirement: 30,
      points: 60,
      isSecret: true,
    ),
    const AchievementDefinition(
      id: 'punishment_survivor',
      title: '惩罚幸存者',
      description: '在接受惩罚后立即完成任务',
      emoji: '💀',
      category: AchievementCategory.secret,
      rarity: AchievementRarity.rare,
      requirement: 1,
      points: 30,
      isSecret: true,
    ),
    const AchievementDefinition(
      id: 'midnight_pigeon',
      title: '午夜鸽子',
      description: '在凌晨3点放鸽子',
      emoji: '🌙',
      category: AchievementCategory.secret,
      rarity: AchievementRarity.rare,
      requirement: 1,
      points: 25,
      isSecret: true,
    ),
    const AchievementDefinition(
      id: 'shameless',
      title: '脸皮够厚',
      description: '连续分享耻辱证书10次',
      emoji: '🧱',
      category: AchievementCategory.secret,
      rarity: AchievementRarity.epic,
      requirement: 10,
      points: 50,
      isSecret: true,
    ),
  ];
}

/// 用户成就状态
class UserAchievement {
  final String achievementId;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int progress;

  UserAchievement({
    required this.achievementId,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0,
  });

  Map<String, dynamic> toJson() => {
    'achievementId': achievementId,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
    'progress': progress,
  };

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      achievementId: json['achievementId'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      progress: json['progress'] ?? 0,
    );
  }
}

/// 成就解锁动画数据
class AchievementUnlockAnimation {
  final String achievementId;
  final String title;
  final String emoji;
  final String description;
  final AchievementRarity rarity;
  final List<AchievementReward> rewards;
  final Duration animationDuration;

  const AchievementUnlockAnimation({
    required this.achievementId,
    required this.title,
    required this.emoji,
    required this.description,
    required this.rarity,
    this.rewards = const [],
    this.animationDuration = const Duration(seconds: 3),
  });
}

/// 成就分享卡片数据
class AchievementShareCard {
  final String achievementId;
  final String title;
  final String emoji;
  final String description;
  final DateTime unlockedAt;
  final int totalPoints;
  final int totalAchievements;

  AchievementShareCard({
    required this.achievementId,
    required this.title,
    required this.emoji,
    required this.description,
    required this.unlockedAt,
    required this.totalPoints,
    required this.totalAchievements,
  });
}

/// 成就墙数据
class AchievementWall {
  final List<UserAchievement> achievements;
  final int totalPoints;
  final int unlockedCount;
  final int totalCount;
  final Map<AchievementCategory, int> categoryProgress;
  final List<AchievementReward> unlockedRewards;

  const AchievementWall({
    this.achievements = const [],
    this.totalPoints = 0,
    this.unlockedCount = 0,
    this.totalCount = 0,
    this.categoryProgress = const {},
    this.unlockedRewards = const [],
  });

  double get completionRate =>
      totalCount > 0 ? unlockedCount / totalCount : 0.0;
}

/// 成就系统服务（升级版）
class AchievementSystemService {
  static const String _achievementsKey = 'achievements_v2';
  static const String _statsKey = 'achievement_stats_v2';
  static const String _rewardsKey = 'unlocked_rewards';

  /// 加载用户成就列表
  static Future<List<UserAchievement>> loadUserAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_achievementsKey);
    if (jsonStr == null) {
      return AchievementDefinition.allAchievements
          .map((a) => UserAchievement(achievementId: a.id))
          .toList();
    }

    final Map<String, dynamic> decoded = jsonDecode(jsonStr);
    return AchievementDefinition.allAchievements.map((def) {
      final data = decoded[def.id];
      if (data != null) {
        return UserAchievement.fromJson(data);
      }
      return UserAchievement(achievementId: def.id);
    }).toList();
  }

  /// 保存用户成就状态
  static Future<void> saveUserAchievements(List<UserAchievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> data = {};
    for (final a in achievements) {
      data[a.achievementId] = a.toJson();
    }
    await prefs.setString(_achievementsKey, jsonEncode(data));
  }

  /// 解锁成就
  static Future<AchievementUnlockAnimation?> unlockAchievement(
    List<UserAchievement> achievements,
    String achievementId,
  ) async {
    final index = achievements.indexWhere((a) => a.achievementId == achievementId);
    if (index == -1) return null;

    final achievement = achievements[index];
    if (achievement.isUnlocked) return null;

    final def = AchievementDefinition.allAchievements.firstWhere(
      (d) => d.id == achievementId,
      orElse: () => AchievementDefinition.allAchievements.first,
    );

    // 检查前置条件
    if (def.prerequisiteId != null) {
      final prereq = achievements.firstWhere(
        (a) => a.achievementId == def.prerequisiteId,
        orElse: () => UserAchievement(achievementId: ''),
      );
      if (!prereq.isUnlocked) return null;
    }

    final unlocked = UserAchievement(
      achievementId: achievementId,
      isUnlocked: true,
      unlockedAt: DateTime.now(),
      progress: def.requirement,
    );

    achievements[index] = unlocked;
    await saveUserAchievements(achievements);

    // 保存奖励
    await _saveUnlockedRewards(def.rewards);

    // 更新统计
    await _updateStats(points: def.points);

    return AchievementUnlockAnimation(
      achievementId: achievementId,
      title: def.title,
      emoji: def.emoji,
      description: def.description,
      rarity: def.rarity,
      rewards: def.rewards,
    );
  }

  /// 更新成就进度
  static Future<List<AchievementUnlockAnimation>> updateProgress(
    List<UserAchievement> achievements,
    String achievementId,
    int progress,
  ) async {
    final unlockedList = <AchievementUnlockAnimation>[];
    final index = achievements.indexWhere((a) => a.achievementId == achievementId);
    if (index == -1) return unlockedList;

    final achievement = achievements[index];
    if (achievement.isUnlocked) return unlockedList;

    final def = AchievementDefinition.allAchievements.firstWhere(
      (d) => d.id == achievementId,
      orElse: () => AchievementDefinition.allAchievements.first,
    );

    achievements[index] = UserAchievement(
      achievementId: achievementId,
      isUnlocked: progress >= def.requirement,
      unlockedAt: progress >= def.requirement ? DateTime.now() : null,
      progress: progress,
    );

    if (progress >= def.requirement && !achievement.isUnlocked) {
      final unlock = await unlockAchievement(achievements, achievementId);
      if (unlock != null) {
        unlockedList.add(unlock);
      }
    }

    await saveUserAchievements(achievements);
    return unlockedList;
  }

  /// 检查并更新基于统计的成就
  static Future<List<AchievementUnlockAnimation>> checkStatAchievements(
    List<UserAchievement> achievements, {
    required int totalFlags,
    required int completedFlags,
    required int totalFails,
    required int totalPardons,
    required int totalExecutions,
    required int consecutiveNoFail,
    required int consecutiveDays,
    required int earlyBirdDays,
    required int weekendCount,
    required int shareCount,
    required int inviteCount,
  }) async {
    final unlockedList = <AchievementUnlockAnimation>[];

    final checks = {
      'first_flag': totalFlags >= 1,
      'flag_collector': totalFlags >= 10,
      'flag_factory': totalFlags >= 50,
      'flag_empire': totalFlags >= 100,
      'first_complete': completedFlags >= 1,
      'complete_10': completedFlags >= 10,
      'complete_50': completedFlags >= 50,
      'complete_100': completedFlags >= 100,
      'no_fail_week': consecutiveDays >= 7,
      'no_fail_month': consecutiveDays >= 30,
      'early_bird': earlyBirdDays >= 7,
      'early_bird_30': earlyBirdDays >= 30,
      'punished_10': totalExecutions >= 10,
      'punished_50': totalExecutions >= 50,
      'survivor': totalPardons >= 1,
      'consecutive_3': consecutiveNoFail >= 3,
      'consecutive_10': consecutiveNoFail >= 10,
      'consecutive_50': consecutiveNoFail >= 50,
      'invite_friend': inviteCount >= 1,
      'invite_5': inviteCount >= 5,
      'invite_10': inviteCount >= 10,
      'execute_10': totalExecutions >= 10,
      'execute_50': totalExecutions >= 50,
      'execute_100': totalExecutions >= 100,
      'share_shame': shareCount >= 10,
      'weekend_warrior': weekendCount >= 4,
      'pigeon_king': totalFails >= 100,
    };

    for (final entry in checks.entries) {
      if (entry.value) {
        final unlock = await unlockAchievement(achievements, entry.key);
        if (unlock != null) {
          unlockedList.add(unlock);
        }
      }
    }

    return unlockedList;
  }

  /// 获取成就墙数据
  static Future<AchievementWall> getAchievementWall() async {
    final achievements = await loadUserAchievements();
    final stats = await _loadStats();

    int totalPoints = 0;
    int unlockedCount = 0;
    final categoryProgress = <AchievementCategory, int>{};
    final unlockedRewards = <AchievementReward>[];

    for (final a in achievements) {
      final def = AchievementDefinition.allAchievements.firstWhere(
        (d) => d.id == a.achievementId,
        orElse: () => AchievementDefinition.allAchievements.first,
      );

      if (a.isUnlocked) {
        totalPoints += def.points;
        unlockedCount++;
        unlockedRewards.addAll(def.rewards);
      }

      categoryProgress[def.category] =
          (categoryProgress[def.category] ?? 0) + (a.isUnlocked ? 1 : 0);
    }

    return AchievementWall(
      achievements: achievements,
      totalPoints: totalPoints,
      unlockedCount: unlockedCount,
      totalCount: AchievementDefinition.allAchievements.length,
      categoryProgress: categoryProgress,
      unlockedRewards: unlockedRewards,
    );
  }

  /// 获取分享卡片数据
  static Future<AchievementShareCard> getShareCard(String achievementId) async {
    final achievements = await loadUserAchievements();
    final achievement = achievements.firstWhere(
      (a) => a.achievementId == achievementId,
      orElse: () => UserAchievement(achievementId: achievementId),
    );

    final def = AchievementDefinition.allAchievements.firstWhere(
      (d) => d.id == achievementId,
      orElse: () => AchievementDefinition.allAchievements.first,
    );

    final wall = await getAchievementWall();

    return AchievementShareCard(
      achievementId: achievementId,
      title: def.title,
      emoji: def.emoji,
      description: def.description,
      unlockedAt: achievement.unlockedAt ?? DateTime.now(),
      totalPoints: wall.totalPoints,
      totalAchievements: wall.unlockedCount,
    );
  }

  /// 获取按分类分组的成就
  static Map<AchievementCategory, List<AchievementDefinition>> getAchievementsByCategory() {
    final map = <AchievementCategory, List<AchievementDefinition>>{};
    for (final a in AchievementDefinition.allAchievements) {
      map.putIfAbsent(a.category, () => []).add(a);
    }
    return map;
  }

  /// 获取按稀有度分组的成就
  static Map<AchievementRarity, List<AchievementDefinition>> getAchievementsByRarity() {
    final map = <AchievementRarity, List<AchievementDefinition>>{};
    for (final a in AchievementDefinition.allAchievements) {
      map.putIfAbsent(a.rarity, () => []).add(a);
    }
    return map;
  }

  /// 获取可见成就（排除未解锁的隐藏成就）
  static List<AchievementDefinition> getVisibleAchievements(
    List<UserAchievement> userAchievements,
  ) {
    return AchievementDefinition.allAchievements.where((def) {
      if (!def.isSecret) return true;
      final ua = userAchievements.firstWhere(
        (a) => a.achievementId == def.id,
        orElse: () => UserAchievement(achievementId: def.id),
      );
      return ua.isUnlocked;
    }).toList();
  }

  /// 保存已解锁奖励
  static Future<void> _saveUnlockedRewards(List<AchievementReward> rewards) async {
    if (rewards.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_rewardsKey);
    final List<dynamic> existing = jsonStr != null ? jsonDecode(jsonStr) : [];
    
    for (final r in rewards) {
      if (!existing.any((e) => e['id'] == r.id)) {
        existing.add(r.toJson());
      }
    }
    
    await prefs.setString(_rewardsKey, jsonEncode(existing));
  }

  /// 获取已解锁奖励
  static Future<List<AchievementReward>> getUnlockedRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_rewardsKey);
    if (jsonStr == null) return [];

    final List<dynamic> rewards = jsonDecode(jsonStr);
    return rewards.map((r) => AchievementReward.fromJson(r)).toList();
  }

  /// 加载统计数据
  static Future<Map<String, int>> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_statsKey);
    if (jsonStr == null) return {};
    return Map<String, int>.from(jsonDecode(jsonStr));
  }

  /// 更新统计数据
  static Future<void> _updateStats({int? points}) async {
    final prefs = await SharedPreferences.getInstance();
    final stats = await _loadStats();

    if (points != null) {
      stats['totalPoints'] = (stats['totalPoints'] ?? 0) + points;
      stats['totalUnlocked'] = (stats['totalUnlocked'] ?? 0) + 1;
    }

    await prefs.setString(_statsKey, jsonEncode(stats));
  }

  /// 清除所有数据
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_achievementsKey);
    await prefs.remove(_statsKey);
    await prefs.remove(_rewardsKey);
  }
}