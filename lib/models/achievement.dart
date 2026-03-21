class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int requirement;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.requirement,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    int? requirement,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      requirement: requirement ?? this.requirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json, Achievement template) {
    return template.copyWith(
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }

  // 预定义成就
  static List<Achievement> get defaultAchievements => [
    const Achievement(
      id: 'first_flag',
      title: '立Flag新手',
      description: '立下第一个Flag',
      emoji: '🚩',
      requirement: 1,
    ),
    const Achievement(
      id: 'flag_collector',
      title: 'Flag收割机',
      description: '累计立下10个Flag',
      emoji: '🏳️',
      requirement: 10,
    ),
    const Achievement(
      id: 'flag_factory',
      title: 'Flag制造厂',
      description: '累计立下50个Flag',
      emoji: '🏭',
      requirement: 50,
    ),
    const Achievement(
      id: 'pigeon_master',
      title: '鸽子大王',
      description: '累计鸽了10次',
      emoji: '🕊️',
      requirement: 10,
    ),
    const Achievement(
      id: 'pigeon_god',
      title: '鸽神降临',
      description: '累计鸽了50次',
      emoji: '👑',
      requirement: 50,
    ),
    const Achievement(
      id: 'survivor',
      title: '劫后余生',
      description: '死党选择"算他过了"',
      emoji: '😮‍💨',
      requirement: 1,
    ),
    const Achievement(
      id: 'executed',
      title: '身经百刑',
      description: '被处刑10次',
      emoji: '💀',
      requirement: 10,
    ),
    const Achievement(
      id: 'no_excuses',
      title: '从不找借口',
      description: '连续3个任务不鸽',
      emoji: '💪',
      requirement: 3,
    ),
  ];
}
