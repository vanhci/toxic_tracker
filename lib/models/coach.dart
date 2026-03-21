class Coach {
  final String id;
  final String name;
  final String emoji;
  final String greeting;
  final String style;
  final bool isPremium;
  final bool isUnlocked;

  Coach({
    required this.id,
    required this.name,
    required this.emoji,
    required this.greeting,
    required this.style,
    this.isPremium = false,
    this.isUnlocked = false,
  });

  Coach copyWith({
    String? id,
    String? name,
    String? emoji,
    String? greeting,
    String? style,
    bool? isPremium,
    bool? isUnlocked,
  }) {
    return Coach(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      greeting: greeting ?? this.greeting,
      style: style ?? this.style,
      isPremium: isPremium ?? this.isPremium,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  static List<Coach> defaultCoaches = [
    Coach(
      id: 'amanda',
      name: 'Amanda',
      emoji: '🙄',
      greeting: '哟，今天准备好让我失望了吗？',
      style: '温柔毒舌',
      isPremium: false,
      isUnlocked: true,
    ),
    Coach(
      id: 'slacker_chief',
      name: '退堂鼓区长',
      emoji: '😴',
      greeting: '别卷了，躺平不好吗？',
      style: '丧系躺平',
      isPremium: true,
      isUnlocked: false,
    ),
    Coach(
      id: 'director_wang',
      name: '扫兴的王主任',
      emoji: '🤨',
      greeting: '年轻人，你这个态度很成问题啊。',
      style: '中年阴阳',
      isPremium: true,
      isUnlocked: false,
    ),
    Coach(
      id: 'coach_tie',
      name: '铁教练',
      emoji: '💪',
      greeting: '你看看你这体格子，爬楼梯都喘，还想立Flag？',
      style: '暴躁健身',
      isPremium: true,
      isUnlocked: false,
    ),
    Coach(
      id: 'teacher_liu',
      name: '刘班主任',
      emoji: '👩‍🏫',
      greeting: '你这个Flag立得，比我当年的教案还草率。',
      style: '阴阳班主任',
      isPremium: true,
      isUnlocked: false,
    ),
    Coach(
      id: 'monk_wu',
      name: '无为大师',
      emoji: '🧘',
      greeting: '施主，放下执念，鸽子也是一种修行。',
      style: '佛系躺平',
      isPremium: true,
      isUnlocked: false,
    ),
  ];
}
