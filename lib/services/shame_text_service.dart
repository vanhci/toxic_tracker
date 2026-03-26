import 'dart:math';

/// 毒舌文案服务 - 生成各种嘲讽和耻辱文案
class ShameTextService {
  static final Random _random = Random();

  /// 根据惩罚等级生成耻辱文案
  static String generateShameText({
    required String taskTitle,
    required int failCount,
    required String coachName,
    int punishmentLevel = 1,
  }) {
    final templates = _getTemplatesForLevel(punishmentLevel);
    final template = templates[_random.nextInt(templates.length)];
    
    return template
        .replaceAll('{task}', taskTitle)
        .replaceAll('{count}', failCount.toString())
        .replaceAll('{coach}', coachName);
  }

  /// 获取社交分享文案
  static String generateShareText({
    required String taskTitle,
    required int failCount,
    required String coachName,
  }) {
    final template = _shareTemplates[_random.nextInt(_shareTemplates.length)];
    
    return template
        .replaceAll('{task}', taskTitle)
        .replaceAll('{count}', failCount.toString())
        .replaceAll('{coach}', coachName);
  }

  /// 获取朋友圈社死文案
  static String generateSocialDeathText({
    required String taskTitle,
    required int failCount,
  }) {
    final template = _socialDeathTemplates[_random.nextInt(_socialDeathTemplates.length)];
    
    return template
        .replaceAll('{task}', taskTitle)
        .replaceAll('{count}', failCount.toString());
  }

  /// 根据惩罚等级获取文案模板
  static List<String> _getTemplatesForLevel(int level) {
    switch (level) {
      case 1: // 轻罚 - 温和嘲讽
        return _lightTemplates;
      case 2: // 中罚 - 中等嘲讽
        return _mediumTemplates;
      case 3: // 重罚 - 毒舌全开
        return _heavyTemplates;
      case 4: // 极刑 - 社死级
        return _extremeTemplates;
      default:
        return _lightTemplates;
    }
  }

  /// 轻度嘲讽模板 (鸽1-2次)
  static final List<String> _lightTemplates = [
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
  ];

  /// 中度嘲讽模板 (鸽3-5次)
  static final List<String> _mediumTemplates = [
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
  ];

  /// 重度嘲讽模板 (鸽6-10次)
  static final List<String> _heavyTemplates = [
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
  ];

  /// 极刑模板 (鸽10次以上)
  static final List<String> _extremeTemplates = [
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
  ];

  /// 社交分享文案模板
  static final List<String> _shareTemplates = [
    '💀 我因为「{task}」被{coach}处刑了，连续鸽了{count}次。欢迎围观我的耻辱时刻！',
    '🙄 「{task}」这件事，我鸽了{count}次。{coach}已经对我绝望了。',
    '🔥 耻辱公告：我的「{task}」flag倒了{count}次。感谢{coach}的"温柔"提醒。',
    '💀 今日战绩：鸽「{task}」{count}次。{coach}送我：公开处刑。',
    '🙄 自律是不可能自律的，这辈子都不可能。{count}次「{task}」。{coach}认证。',
    '🔥 关于我「{task}」这件事……{count}次。{coach}已崩溃。',
  ];

  /// 朋友圈社死文案模板
  static final List<String> _socialDeathTemplates = [
    '🚨 紧急公告 🚨\n我，立flag大户，再次成功把「{task}」鸽了整整{count}次。\n\n我现在郑重向所有人道歉，并接受所有嘲讽。\n\n#今天鸽了吗 #自律是不可能自律的',
    '📣 重要通知 📣\n\n经过不懈努力，我已经成功把「{task}」这件事搞砸了{count}次。\n\n这是一个值得铭记的时刻，请大家为我作证。\n\n#Flag回收计划 #专业鸽子',
    '📢 公开处刑 📢\n\n任务：「{task}」\n状态：已鸽\n次数：{count}次\n\n没错，你没看错。这就是我。\n\n欢迎所有认识我的人截图留念。\n\n#今天鸽了吗 #这flag我不立了',
    '💀 耻辱证书 💀\n\n兹证明本人在「{task}」这件事上已连续放弃{count}次。\n\n特此公告，以儆效尤。\n\n#自律失败学 #Flag收割机',
    '🔥 社死现场 🔥\n\n「{task}」\n执行次数：0\n放弃次数：{count}\n\n我要这自律有何用？\n\n#今天鸽了吗 #人类迷惑行为',
    '🚩 Flag回收 🚩\n\n「{task}」这个flag，我已经成功回收了{count}次。\n\n没有人比我更懂放弃。\n\n#专业放鸽子 #自律是什么',
  ];

  /// 获取弹窗嘲讽文案
  static List<String> getAnnoyingPopupTexts() {
    return [
      '你还好吗？',
      '反省一下吧。',
      '别挣扎了。',
      '接受现实吧。',
      '这次真的没救了。',
      '放弃吧，你已经很努力了。',
      '继续反省。',
      '时间还没到。',
      '乖乖受罚。',
      '别想逃跑。',
      '放弃抵抗。',
      '你逃不掉的。',
      '继续反省吧。',
      '还有很～久。',
      '嘿嘿嘿。',
    ];
  }

  /// 获取随机弹窗文案
  static String getRandomPopupText() {
    final texts = getAnnoyingPopupTexts();
    return texts[_random.nextInt(texts.length)];
  }

  /// 根据教练风格获取定制嘲讽
  static String getCoachSpecificShame({
    required String coachId,
    required String taskTitle,
    required int failCount,
  }) {
    switch (coachId) {
      case 'amanda':
        return _getAmandaShame(taskTitle, failCount);
      case 'slacker_chief':
        return _getSlackerShame(taskTitle, failCount);
      case 'director_wang':
        return _getDirectorWangShame(taskTitle, failCount);
      case 'coach_tie':
        return _getCoachTieShame(taskTitle, failCount);
      case 'teacher_liu':
        return _getTeacherLiuShame(taskTitle, failCount);
      case 'monk_wu':
        return _getMonkWuShame(taskTitle, failCount);
      default:
        return generateShameText(
          taskTitle: taskTitle,
          failCount: failCount,
          coachName: '教练',
          punishmentLevel: 1,
        );
    }
  }

  static String _getAmandaShame(String task, int count) {
    final options = [
      '「$task」又鸽了？我早就知道你会这样。$count次了呢。',
      '唉，你这自律能力，真是让我头疼。$count次了。',
      '算了，罚你冷静冷静吧。$count次啊……',
      '你知道吗？我已经不抱希望了。$count次「$task」。',
    ];
    return options[_random.nextInt(options.length)];
  }

  static String _getSlackerShame(String task, int count) {
    final options = [
      '「$task」？不做了吧，反正也没人期待。$count次了。',
      '躺平吧，躺平多舒服啊。鸽了$count次很正常。',
      '惩罚？不存在的，继续睡吧。不过$count次确实有点多了。',
      '我已经懒得吐槽你了。$count次「$task」。',
    ];
    return options[_random.nextInt(options.length)];
  }

  static String _getDirectorWangShame(String task, int count) {
    final options = [
      '「$task」这个事情，你的态度很成问题啊。$count次了。',
      '年轻人，要懂得承担责任。$count次！',
      '去，面壁思过30秒。$count次「$task」，你让我很失望。',
      '你这个状态，我很难办啊。$count次了。',
    ];
    return options[_random.nextInt(options.length)];
  }

  static String _getCoachTieShame(String task, int count) {
    final options = [
      '「$task」？你看看你这执行力！$count次！',
      '给我去做30个深蹲！不对，是30秒反思！$count次啊！',
      '弱鸡！罚你30秒！$count次「$task」！',
      '你这体格子不行，心态更不行！$count次了！',
    ];
    return options[_random.nextInt(options.length)];
  }

  static String _getTeacherLiuShame(String task, int count) {
    final options = [
      '「$task」，你这个任务完成得，比小明还差。$count次。',
      '罚你站30秒，好好反省。全班就你鸽了$count次。',
      '你看看人家，再看看你。$count次「$task」。',
      '你这个态度，是不是不想进步了？$count次了。',
    ];
    return options[_random.nextInt(options.length)];
  }

  static String _getMonkWuShame(String task, int count) {
    final options = [
      '「$task」，施主，放下执念，鸽子也是一种因果。$count次了。',
      '静坐30秒，观照内心。$count次「$task」，皆是业障。',
      '阿弥陀佛，罚你冥想30秒。$count次，放下吧。',
      '一切有为法，如梦幻泡影。「$task」$count次，亦是如此。',
    ];
    return options[_random.nextInt(options.length)];
  }
}
