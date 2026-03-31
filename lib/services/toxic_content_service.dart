import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 毒舌强度等级
enum ToxicIntensity {
  gentle,   // 温柔 - 轻度嘲讽
  standard, // 标准 - 正常毒舌
  hell,     // 地狱 - 极其毒舌
}

/// 任务类型
enum TaskType {
  work,     // 工作
  study,    // 学习
  health,   // 健康
  social,   // 社交
  finance,  // 财务
  hobby,    // 爱好
  other,    // 其他
}

/// 节日类型
enum FestivalType {
  none,
  valentinesDay,    // 情人节
  springFestival,   // 春节
  newYear,          // 元旦
  nationalDay,      // 国庆
  midAutumn,        // 中秋
  dragonBoat,       // 端午
  qingming,         // 清明
  labourDay,        // 劳动节
  monday,           // 周一
  friday,           // 周五
  weekend,          // 周末
  birthday,         // 用户生日（特殊）
}

/// 用户行为数据（用于个性化毒舌）
class UserBehaviorData {
  final int totalTasks;
  final int completedTasks;
  final int failedTasks;
  final int consecutiveFails;
  final int longestStreak;
  final List<String> recentTaskTypes;
  final Map<String, int> failByType;
  final int totalPunishmentsReceived;
  final int timesPardoned;

  const UserBehaviorData({
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.failedTasks = 0,
    this.consecutiveFails = 0,
    this.longestStreak = 0,
    this.recentTaskTypes = const [],
    this.failByType = const {},
    this.totalPunishmentsReceived = 0,
    this.timesPardoned = 0,
  });

  double get completionRate =>
      totalTasks > 0 ? completedTasks / totalTasks : 0.0;

  double get failRate =>
      totalTasks > 0 ? failedTasks / totalTasks : 0.0;

  String get mostFailedType {
    if (failByType.isEmpty) return 'other';
    return failByType.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  Map<String, dynamic> toJson() => {
    'totalTasks': totalTasks,
    'completedTasks': completedTasks,
    'failedTasks': failedTasks,
    'consecutiveFails': consecutiveFails,
    'longestStreak': longestStreak,
    'recentTaskTypes': recentTaskTypes,
    'failByType': failByType,
    'totalPunishmentsReceived': totalPunishmentsReceived,
    'timesPardoned': timesPardoned,
  };

  factory UserBehaviorData.fromJson(Map<String, dynamic> json) {
    return UserBehaviorData(
      totalTasks: json['totalTasks'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
      failedTasks: json['failedTasks'] ?? 0,
      consecutiveFails: json['consecutiveFails'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      recentTaskTypes: List<String>.from(json['recentTaskTypes'] ?? []),
      failByType: Map<String, int>.from(json['failByType'] ?? {}),
      totalPunishmentsReceived: json['totalPunishmentsReceived'] ?? 0,
      timesPardoned: json['timesPardoned'] ?? 0,
    );
  }
}

/// 自定义毒舌模板
class ToxicTemplate {
  final String id;
  final String template;
  final ToxicIntensity intensity;
  final TaskType? taskType;
  final bool isDefault;
  final DateTime createdAt;

  ToxicTemplate({
    required this.id,
    required this.template,
    required this.intensity,
    this.taskType,
    this.isDefault = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'template': template,
    'intensity': intensity.index,
    'taskType': taskType?.index,
    'isDefault': isDefault,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ToxicTemplate.fromJson(Map<String, dynamic> json) {
    return ToxicTemplate(
      id: json['id'],
      template: json['template'],
      intensity: ToxicIntensity.values[json['intensity'] ?? 1],
      taskType: json['taskType'] != null
          ? TaskType.values[json['taskType']]
          : null,
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// 毒舌内容扩充服务
class ToxicContentService {
  static final Random _random = Random();
  static const String _templatesKey = 'toxic_templates';
  static const String _settingsKey = 'toxic_settings';

  /// 获取当前节日
  static FestivalType getCurrentFestival() {
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;
    final weekday = now.weekday;

    // 周一/周五/周末
    if (weekday == 1) return FestivalType.monday;
    if (weekday == 5) return FestivalType.friday;
    if (weekday == 6 || weekday == 7) return FestivalType.weekend;

    // 固定节日
    if (month == 2 && day == 14) return FestivalType.valentinesDay;
    if (month == 1 && day == 1) return FestivalType.newYear;
    if (month == 5 && day == 1) return FestivalType.labourDay;
    if (month == 10 && day == 1) return FestivalType.nationalDay;

    // 农历节日需要特殊计算，这里简化处理
    // 实际项目中可以用 lunar 库精确计算
    return FestivalType.none;
  }

  /// 根据逾期天数获取惩罚等级
  static int getPunishmentLevel(int overdueDays) {
    if (overdueDays <= 3) return 1;  // 轻度
    if (overdueDays <= 7) return 2;  // 中度
    return 3;                         // 重度
  }

  /// 根据任务类型获取特定毒舌
  static List<String> getToxicByTaskType(TaskType taskType, ToxicIntensity intensity) {
    switch (taskType) {
      case TaskType.work:
        return intensity == ToxicIntensity.gentle
            ? _workToxicGentle
            : intensity == ToxicIntensity.standard
                ? _workToxicStandard
                : _workToxicHell;
      case TaskType.study:
        return intensity == ToxicIntensity.gentle
            ? _studyToxicGentle
            : intensity == ToxicIntensity.standard
                ? _studyToxicStandard
                : _studyToxicHell;
      case TaskType.health:
        return intensity == ToxicIntensity.gentle
            ? _healthToxicGentle
            : intensity == ToxicIntensity.standard
                ? _healthToxicStandard
                : _healthToxicHell;
      case TaskType.social:
        return intensity == ToxicIntensity.gentle
            ? _socialToxicGentle
            : intensity == ToxicIntensity.standard
                ? _socialToxicStandard
                : _socialToxicHell;
      case TaskType.finance:
        return intensity == ToxicIntensity.gentle
            ? _financeToxicGentle
            : intensity == ToxicIntensity.standard
                ? _financeToxicStandard
                : _financeToxicHell;
      case TaskType.hobby:
        return intensity == ToxicIntensity.gentle
            ? _hobbyToxicGentle
            : intensity == ToxicIntensity.standard
                ? _hobbyToxicStandard
                : _hobbyToxicHell;
      default:
        return intensity == ToxicIntensity.gentle
            ? _generalToxicGentle
            : intensity == ToxicIntensity.standard
                ? _generalToxicStandard
                : _generalToxicHell;
    }
  }

  /// 节日特供毒舌
  static List<String> getFestivalToxic(FestivalType festival, ToxicIntensity intensity) {
    switch (festival) {
      case FestivalType.valentinesDay:
        return intensity == ToxicIntensity.hell
            ? _valentinesDayToxicHell
            : _valentinesDayToxic;
      case FestivalType.springFestival:
        return _springFestivalToxic;
      case FestivalType.newYear:
        return _newYearToxic;
      case FestivalType.nationalDay:
        return _nationalDayToxic;
      case FestivalType.monday:
        return _mondayToxic;
      case FestivalType.friday:
        return _fridayToxic;
      case FestivalType.weekend:
        return _weekendToxic;
      case FestivalType.midAutumn:
        return _midAutumnToxic;
      case FestivalType.dragonBoat:
        return _dragonBoatToxic;
      case FestivalType.qingming:
        return _qingmingToxic;
      case FestivalType.labourDay:
        return _labourDayToxic;
      case FestivalType.birthday:
        return _birthdayToxic;
      default:
        return [];
    }
  }

  /// 生成个性化毒舌
  static String generatePersonalizedToxic({
    required String taskTitle,
    required int failCount,
    required String coachName,
    required UserBehaviorData behaviorData,
    TaskType taskType = TaskType.other,
    ToxicIntensity intensity = ToxicIntensity.standard,
    int? overdueDays,
  }) {
    // 检查节日特供
    final festival = getCurrentFestival();
    if (festival != FestivalType.none && _random.nextDouble() < 0.3) {
      final festivalToxics = getFestivalToxic(festival, intensity);
      if (festivalToxics.isNotEmpty) {
        final template = festivalToxics[_random.nextInt(festivalToxics.length)];
        return _applyTemplate(template, taskTitle, failCount, coachName, behaviorData);
      }
    }

    // 根据失败率调整语气
    final adjustedIntensity = behaviorData.failRate > 0.8
        ? ToxicIntensity.hell
        : intensity;

    // 获取任务类型特定毒舌
    final taskToxics = getToxicByTaskType(taskType, adjustedIntensity);
    
    // 混合通用毒舌
    final allToxics = [
      ...taskToxics,
      ..._getGeneralToxics(adjustedIntensity, overdueDays ?? failCount),
    ];

    final template = allToxics[_random.nextInt(allToxics.length)];
    return _applyTemplate(template, taskTitle, failCount, coachName, behaviorData);
  }

  /// 应用模板变量
  static String _applyTemplate(
    String template,
    String taskTitle,
    int failCount,
    String coachName,
    UserBehaviorData behaviorData,
  ) {
    return template
        .replaceAll('{task}', taskTitle)
        .replaceAll('{count}', failCount.toString())
        .replaceAll('{coach}', coachName)
        .replaceAll('{rate}', '${(behaviorData.failRate * 100).toStringAsFixed(0)}%')
        .replaceAll('{streak}', behaviorData.longestStreak.toString())
        .replaceAll('{total}', behaviorData.totalTasks.toString())
        .replaceAll('{failed}', behaviorData.failedTasks.toString());
  }

  // ==================== 通用毒舌库（按逾期天数分级） ====================

  /// 轻度毒舌（1-3天）
  static const List<String> _lightToxic = [
    '「{task}」啊……你就这？',
    '{coach}表示：我不意外，真的。',
    '又一次！「{task}」被你鸽了。',
    '第{count}次了，你还好意思？',
    '「{task}」？不存在的。',
    '{coach}叹了口气。',
    '听说「{task}」又凉了？',
    '啧啧啧，「{task}」这事……',
    '{coach}早就看穿你了。',
    '别解释了，「{task}」没了。',
    '今天又是放弃的一天呢~',
    '「{task}」表示：我习惯了。',
    '{coach}：我预判了你的预判。',
    '放弃也很正常嘛（狗头）',
    '「{task}」已经是个传说。',
    '继续加油！加油放弃！',
    '{coach}送你一个鼓励的眼神（假的）',
    '这flag插得好啊，稳稳地倒。',
    '「{task}」？哦，那个不存在的。',
    '习惯就好，{coach}已经习惯了。',
  ];

  /// 中度毒舌（4-7天）
  static const List<String> _mediumToxic = [
    '「{task}」连续鸽了{count}次，你脸皮够厚的。',
    '{coach}已经无语了。{count}次啊{count}次！',
    '「{task}」？你确定这flag还能立起来吗？',
    '连续{count}次！{coach}送你一个白眼🙄',
    '你的「{task}」已经彻底放弃了。',
    '{coach}：我早就知道会这样。{count}次！',
    '「{task}」？不如改成「不存在的任务」吧。',
    '第{count}次鸽了。{coach}已经习惯了。',
    '你的自律能力呢？「{task}」{count}次！',
    '{coach}：我能说什么呢？{count}次啊。',
    '一周了，你的「{task}」还在等你呢（并没有）',
    '坚持不懈地放弃，也是一种才能。',
    '{coach}：来，跟我念：自-律-不-存-在',
    '「{task}」：我凉了，你呢？',
    '你的毅力真是令人叹为观止（反向）',
    '{count}次了，该破纪录了吧？',
    '{coach}建议你改名叫"鸽子精"。',
    '「{task}」已经彻底放弃了治疗。',
    '自律这东西，你好像真的没有。',
    'flag倒了可以再立，但你这立一个倒一个……',
  ];

  /// 重度毒舌（8+天）
  static const List<String> _heavyToxic = [
    '「{task}」{count}次！你是不是对自律有什么误解？',
    '{coach}已经不想说话了。{count}次，你赢了。',
    '连续鸽了{count}次，你这flag是纸糊的吗？',
    '「{task}」？{count}次？你的人生也差不多这样了吧。',
    '{coach}：我见过废的，没见过这么废的。{count}次！',
    '第{count}次！「{task}」已经成了你的笑话。',
    '自律？不存在的。{count}次「{task}」。',
    '{coach}：我无话可说。{count}次。',
    '「{task}」{count}次，你可以去申请吉尼斯了。',
    '你的自控力和「{task}」一样，都是幻觉。{count}次！',
    '{count}天了！「{task}」已经成了化石。',
    '你的意志力比豆腐还嫩。',
    '{coach}：我服了，彻底服了。',
    '「{task}」？{count}天？你认真的吗？',
    '建议你放弃立flag，直接躺平算了。',
    '{count}次的失败，也是一种成就吧？',
    '{coach}决定把你的名字改成"鸽子王"。',
    '「{task}」已经变成了都市传说。',
    '你的自律能力已经突破了人类底线。',
    '{count}天，你创造了新的放弃记录！',
  ];

  /// 极刑毒舌（10+次或极端情况）
  static const List<String> _extremeToxic = [
    '「{task}」{count}次！你已经超越了人类认知的底线！',
    '{coach}：我服了。真的服了。{count}次是什么概念你知道吗？',
    '连续{count}次！「{task}」已经成了你人生的墓志铭。',
    '你的「{task}」被鸽了{count}次。这不是记录，这是耻辱柱。',
    '{coach}：{count}次。我词穷了。你赢了。',
    '「{task}」{count}次！建议直接改名叫「不可能完成的任务」。',
    '第{count}次！你已经成功把「{task}」变成了一个传说。',
    '{coach}：我见证了一个奇迹的诞生——{count}次的失败。',
    '「{task}」？{count}次？你已经不是人类了。',
    '{count}次！{coach}决定把这一天定为「你放弃{task}纪念日」。',
    '恭喜你达成「{count}次放弃」成就！解锁称号：鸽子王中王',
    '「{task}」已经彻底从你的生命中消失了，恭喜！',
    '{coach}：我要把这个写进吉尼斯世界纪录。',
    '你的坚持……坚持放弃，真是令人钦佩。',
    '{count}次，你已经超越了"人类"这个概念。',
    '「{task}」对你来说，就是传说中的任务。',
    '{coach}宣布：你是历史上最成功的鸽子。',
    '放弃的艺术，你已经达到了宗师级别。',
    '{count}次。这不是数字，这是你的传奇。',
    '「{task}」已经从待办变成了传说，从传说变成了神话。',
  ];

  static List<String> _getGeneralToxics(ToxicIntensity intensity, int count) {
    final level = getPunishmentLevel(count);
    if (level == 1) return _lightToxic;
    if (level == 2) return _mediumToxic;
    if (intensity == ToxicIntensity.hell) return _extremeToxic;
    return _heavyToxic;
  }

  // ==================== 工作类毒舌 ====================

  static const List<String> _workToxicGentle = [
    '工作再忙，「{task}」也不能忘哦~',
    '{coach}：上班族要自律哦。',
    '「{task}」没完成，老板知道吗？',
    '工作党也要立得住flag。',
    '今天的「{task}」，明天的工作？',
  ];

  static const List<String> _workToxicStandard = [
    '工作效率这么高，「{task}」怎么就鸽了？',
    '{coach}：你的工作效率都用在哪了？',
    '「{task}」{count}次，老板不查考勤吗？',
    '工作都做不完，还想做「{task}」？',
    '摸鱼可以，但「{task}」不能一直摸。',
    '{count}次了，你确定不是在划水？',
  ];

  static const List<String> _workToxicHell = [
    '「{task}」{count}次，建议你把自律加入KPI。',
    '{coach}：你这样，年终奖还想不想要？',
    '工作时间划水，「{task}」时间放鸽子，你是天才吗？',
    '你老板要是知道你「{task}」鸽了{count}次，会怎么想？',
    '「{task}」？工作都做不好还想做这个？笑话。',
    '{count}次！建议你直接和"自律"两个字绝交。',
  ];

  // ==================== 学习类毒舌 ====================

  static const List<String> _studyToxicGentle = [
    '学习要专注，「{task}」也要坚持。',
    '{coach}：学习计划不能落哦。',
    '「{task}」放了，考试可不会放你。',
    '今天的「{task}」，明天的成绩。',
    '学习党加油！别让「{task}」凉了。',
  ];

  static const List<String> _studyToxicStandard = [
    '「{task}」{count}次，书都看不下去了？',
    '{coach}：你的学习计划是不是只有计划没有执行？',
    '学习不是为了「{task}」，但「{task}」能帮你学习。',
    '{count}次！你这样，考试能过吗？',
    '「{task}」鸽了，脑子也跟着鸽了？',
    '学习计划：列了{count}次，执行了0次。',
  ];

  static const List<String> _studyToxicHell = [
    '「{task}」{count}次，你确定你是来学习的？',
    '{coach}：你这样下去，毕业都成问题。',
    '学习？自律都没有，还谈学习？',
    '{count}次「{task}」，建议你重修"自律"这门课。',
    '「{task}」对你来说，比考满分还难。',
    '{coach}：我建议你先学会自律，再谈学习。',
  ];

  // ==================== 健康类毒舌 ====================

  static const List<String> _healthToxicGentle = [
    '健康最重要，「{task}」要坚持哦。',
    '{coach}：身体是革命的本钱。',
    '「{task}」鸽了，身体可不会等你。',
    '今天的「{task}」，明天的健康。',
    '别让「{task}」成为你的遗憾。',
  ];

  static const List<String> _healthToxicStandard = [
    '「{task}」{count}次，你这是在透支生命。',
    '{coach}：你确定你的身体能承受这种放肆？',
    '健康任务「{task}」都敢鸽，胆子够大。',
    '{count}次！你的身体在抗议。',
    '「{task}」？身体垮了，什么都完了。',
    '健身房会员卡都比你的「{task}」执行率高。',
  ];

  static const List<String> _healthToxicHell = [
    '「{task}」{count}次，你的身体正在写遗书。',
    '{coach}：你这是在慢性自杀。',
    '健康都不要了，还想干啥？',
    '{count}次！建议直接办张医院VIP卡。',
    '「{task}」对你来说，比登天还难。',
    '{coach}：你的自律能力和你的体质一样弱。',
  ];

  // ==================== 社交类毒舌 ====================

  static const List<String> _socialToxicGentle = [
    '社交也很重要，「{task}」别放了。',
    '{coach}：朋友要常联系哦。',
    '「{task}」鸽了，朋友可不会一直等你。',
    '今天的「{task}」，明天的人脉。',
    '别让朋友失望。',
  ];

  static const List<String> _socialToxicStandard = [
    '「{task}」{count}次，朋友都快跑光了。',
    '{coach}：你这样下去，朋友圈会变成空城。',
    '社交任务「{task}」都鸽，你是想当隐士？',
    '{count}次！你朋友知道你这么不靠谱吗？',
    '「{task}」鸽了，朋友也跟着鸽了。',
    '你的社交圈正在以「{task}」的速度缩小。',
  ];

  static const List<String> _socialToxicHell = [
    '「{task}」{count}次，你还有朋友吗？',
    '{coach}：你这样，以后只能和鸽子做朋友了。',
    '社交？你连「{task}」都做不到，还想社交？',
    '{count}次！你的通讯录可能要清空了。',
    '「{task}」对你来说，比交朋友还难。',
    '{coach}：我建议你先学会对自己负责，再谈社交。',
  ];

  // ==================== 财务类毒舌 ====================

  static const List<String> _financeToxicGentle = [
    '理财要自律，「{task}」要坚持。',
    '{coach}：钱包在等你。',
    '「{task}」鸽了，钱包可能会哭。',
    '今天的「{task}」，明天的财富。',
    '别让「{task}」变成你的财务漏洞。',
  ];

  static const List<String> _financeToxicStandard = [
    '「{task}」{count}次，你的钱包在抗议。',
    '{coach}：你这样理财，钱包会越来越瘦。',
    '财务任务「{task}」都鸽，你是钱多吗？',
    '{count}次！你的存款正在哭泣。',
    '「{task}」鸽了，下个月吃土？',
    '你的理财计划和「{task}」一起凉了。',
  ];

  static const List<String> _financeToxicHell = [
    '「{task}」{count}次，建议你把钱都捐了算了。',
    '{coach}：你这理财水平，还是存定期吧。',
    '财务自由？你连「{task}」自由都没有。',
    '{count}次！你的钱包已经放弃挣扎。',
    '「{task}」对你来说，比赚钱还难。',
    '{coach}：我建议你先学会管住自己，再学会管钱。',
  ];

  // ==================== 爱好类毒舌 ====================

  static const List<String> _hobbyToxicGentle = [
    '爱好也要坚持，「{task}」别放了。',
    '{coach}：兴趣是最好的老师。',
    '「{task}」鸽了，兴趣可不会等你。',
    '今天的「{task}」，明天的成就感。',
    '别让「{task}」变成你的遗憾。',
  ];

  static const List<String> _hobbyToxicStandard = [
    '「{task}」{count}次，你的爱好是真爱好还是假爱好？',
    '{coach}：你这样下去，爱好会变成回忆。',
    '爱好任务「{task}」都鸽，你还说这是爱好？',
    '{count}次！你的热情正在消退。',
    '「{task}」鸽了，兴趣也跟着凉了。',
    '你的爱好清单比「{task}」完成率高吗？',
  ];

  static const List<String> _hobbyToxicHell = [
    '「{task}」{count}次，建议你把"爱好"两个字删了。',
    '{coach}：你这不是爱好，是口号。',
    '爱好？你连「{task}」都坚持不了。',
    '{count}次！你的爱好正在变成笑话。',
    '「{task}」对你来说，只是一个美好的愿望。',
    '{coach}：我建议你找个不需要坚持的爱好。',
  ];

  // ==================== 其他类毒舌 ====================

  static const List<String> _generalToxicGentle = [
    '「{task}」也要认真对待哦。',
    '{coach}：每个任务都值得尊重。',
    '「{task}」鸽了，可要好好反省。',
    '今天的「{task}」，明天的你。',
    '加油，别放弃！',
  ];

  static const List<String> _generalToxicStandard = [
    '「{task}」{count}次，你是不是对自己的承诺有什么误解？',
    '{coach}：你这样下去，连自己都不信任自己了。',
    '{count}次！你的承诺就像空气。',
    '「{task}」鸽了，信用也跟着降。',
    '承诺「{task}」的时候，你是认真的吗？',
  ];

  static const List<String> _generalToxicHell = [
    '「{task}」{count}次，你已经超越了"不靠谱"的定义。',
    '{coach}：你的承诺比薄纸还脆。',
    '信用破产！{count}次！',
    '「{task}」对你来说，只是一个数字。',
    '{coach}：我建议你别再承诺任何事情了。',
  ];

  // ==================== 节日特供毒舌 ====================

  static const List<String> _valentinesDayToxic = [
    '情人节快乐！「{task}」也快乐地鸽了。',
    '{coach}：今天情人节，你却在这里鸽任务？',
    '「{task}」{count}次，你确定不是在逃避什么？',
    '你的对象知道你在「{task}」上这么不靠谱吗？',
    '情人节礼物：一个鸽了{count}次的「{task}」。',
  ];

  static const List<String> _valentinesDayToxicHell = [
    '情人节没人陪，「{task}」也放你鸽子，完美。',
    '{coach}：怪不得你单身，「{task}」{count}次谁受得了？',
    '建议你先把「{task}」搞定，再考虑脱单的事。',
    '{count}次「{task}」，你的情路和自律一样坎坷。',
    '你的对象要是在这，估计也被「{task}」{count}次气跑了。',
  ];

  static const List<String> _springFestivalToxic = [
    '新年快乐！「{task}」也新年快乐地鸽了。',
    '{coach}：恭喜发财，自律……算了。',
    '「{task}」{count}次，新的一年新的……鸽？',
    '新年愿望：完成「{task}」。现实：{count}次。',
    '过年了，连「{task}」都想放假。',
  ];

  static const List<String> _newYearToxic = [
    '元旦快乐！「{task}」也从去年鸽到了今年。',
    '{coach}：新年新气象，你的「{task}」还是老样子。',
    '「{task}」{count}次，跨年跨了个寂寞。',
    '新年决心：完成「{task}」。现状：{count}次。',
    '2026年了，你的「{task}」还在2025年等你。',
  ];

  static const List<String> _nationalDayToxic = [
    '国庆快乐！「{task}」也放假了。',
    '{coach}：黄金周，你的自律也休假了？',
    '「{task}」{count}次，国庆七天乐，鸽子更乐。',
    '祖国母亲生日快乐，你的「{task}」呢？',
    '国庆旅游？先把「{task}」搞定吧。',
  ];

  static const List<String> _mondayToxic = [
    '周一综合症？「{task}」也跟着综合了。',
    '{coach}：周一就想放弃，你是有多标准？',
    '「{task}」{count}次，周一的你更想躺平。',
    '周一开工，「{task}」不开工。',
    '又是周一，又是鸽「{task}」的一天。',
  ];

  static const List<String> _fridayToxic = [
    '周五了，「{task}」也想提前下班。',
    '{coach}：周五就要放飞？「{task}」怎么办？',
    '「{task}」{count}次，周五的借口最多了。',
    '周末来了，「{task}」也跟着跑了。',
    '周五的快乐，「{task}」的悲伤。',
  ];

  static const List<String> _weekendToxic = [
    '周末愉快！「{task}」也愉快地消失了。',
    '{coach}：周末不是你鸽「{task}」的理由。',
    '「{task}」{count}次，周末加起来都鸽满了。',
    '周末是用来休息的，不是用来鸽「{task}」的。',
    '你的周末：睡懒觉、刷手机、鸽「{task}」。',
  ];

  static const List<String> _midAutumnToxic = [
    '中秋快乐！「{task}」和月亮一起圆了（假的）。',
    '{coach}：吃月饼的时候想想「{task}」。',
    '「{task}」{count}次，月圆任务不圆。',
    '团圆的日子，「{task}」也团圆不了。',
    '月饼好吃，自律难守，「{task}」难成。',
  ];

  static const List<String> _dragonBoatToxic = [
    '端午快乐！「{task}」和粽子一起被吃掉了。',
    '{coach}：粽叶包不住你鸽「{task}」的心。',
    '「{task}」{count}次，龙舟都划不动了。',
    '端午赛龙舟，你赛的是鸽「{task}」。',
    '吃粽子不忘「{task}」……哦不对，你忘了。',
  ];

  static const List<String> _qingmingToxic = [
    '清明时节雨纷纷，「{task}」被你鸽断魂。',
    '{coach}：清明扫墓，顺便祭奠一下「{task}」。',
    '「{task}」{count}次，已经可以立碑了。',
    '清明雨上，「{task}」凉透。',
    '祭奠先人，也别忘了祭奠「{task}」。',
  ];

  static const List<String> _labourDayToxic = [
    '劳动节快乐！「{task}」表示不劳动。',
    '{coach}：劳动最光荣，你鸽「{task}」最光荣。',
    '「{task}」{count}次，劳动节你不配。',
    '五一劳动，「{task}」不劳动。',
    '劳动节放假，「{task}」也跟着放假。',
  ];

  static const List<String> _birthdayToxic = [
    '生日快乐！「{task}」送你的礼物是……又一鸽。',
    '{coach}：生日愿望是完成「{task}」吗？',
    '「{task}」{count}次，生日特供鸽。',
    '又老了一岁，「{task}」还在原地。',
    '生日蛋糕可以切，「{task}」不能切。',
  ];

  // ==================== 持久化设置 ====================

  /// 保存毒舌强度设置
  static Future<void> saveIntensitySetting(ToxicIntensity intensity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_settingsKey.intensity', intensity.index);
  }

  /// 加载毒舌强度设置
  static Future<ToxicIntensity> loadIntensitySetting() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('$_settingsKey.intensity') ?? 1;
    return ToxicIntensity.values[index];
  }

  /// 保存自定义模板
  static Future<void> saveCustomTemplates(List<ToxicTemplate> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = templates.map((t) => t.toJson()).toList();
    await prefs.setString(_templatesKey, jsonEncode(jsonList));
  }

  /// 加载自定义模板
  static Future<List<ToxicTemplate>> loadCustomTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_templatesKey);
    if (jsonStr == null) return [];
    
    final jsonList = jsonDecode(jsonStr) as List;
    return jsonList.map((j) => ToxicTemplate.fromJson(j)).toList();
  }

  /// 添加自定义模板
  static Future<void> addCustomTemplate(ToxicTemplate template) async {
    final templates = await loadCustomTemplates();
    templates.add(template);
    await saveCustomTemplates(templates);
  }

  /// 删除自定义模板
  static Future<void> deleteCustomTemplate(String id) async {
    final templates = await loadCustomTemplates();
    templates.removeWhere((t) => t.id == id);
    await saveCustomTemplates(templates);
  }

  /// 获取总毒舌数量
  static int getTotalToxicCount() {
    return _lightToxic.length +
        _mediumToxic.length +
        _heavyToxic.length +
        _extremeToxic.length +
        _workToxicGentle.length +
        _workToxicStandard.length +
        _workToxicHell.length +
        _studyToxicGentle.length +
        _studyToxicStandard.length +
        _studyToxicHell.length +
        _healthToxicGentle.length +
        _healthToxicStandard.length +
        _healthToxicHell.length +
        _socialToxicGentle.length +
        _socialToxicStandard.length +
        _socialToxicHell.length +
        _financeToxicGentle.length +
        _financeToxicStandard.length +
        _financeToxicHell.length +
        _hobbyToxicGentle.length +
        _hobbyToxicStandard.length +
        _hobbyToxicHell.length +
        _valentinesDayToxic.length +
        _valentinesDayToxicHell.length +
        _springFestivalToxic.length +
        _newYearToxic.length +
        _nationalDayToxic.length +
        _mondayToxic.length +
        _fridayToxic.length +
        _weekendToxic.length +
        _midAutumnToxic.length +
        _dragonBoatToxic.length +
        _qingmingToxic.length +
        _labourDayToxic.length +
        _birthdayToxic.length;
  }
}