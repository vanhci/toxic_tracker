import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ];

  // 标题
  String get appTitle => _localizedValues[locale.languageCode]?['appTitle'] ?? _localizedValues['zh']!['appTitle']!;
  String get homeTitle => _localizedValues[locale.languageCode]?['homeTitle'] ?? _localizedValues['zh']!['homeTitle']!;

  // 按钮
  String get addFlag => _localizedValues[locale.languageCode]?['addFlag'] ?? _localizedValues['zh']!['addFlag']!;
  String get confirm => _localizedValues[locale.languageCode]?['confirm'] ?? _localizedValues['zh']!['confirm']!;
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? _localizedValues['zh']!['cancel']!;
  String get share => _localizedValues[locale.languageCode]?['share'] ?? _localizedValues['zh']!['share']!;

  // 任务
  String get taskTitle => _localizedValues[locale.languageCode]?['taskTitle'] ?? _localizedValues['zh']!['taskTitle']!;
  String get taskDeadline => _localizedValues[locale.languageCode]?['taskDeadline'] ?? _localizedValues['zh']!['taskDeadline']!;
  String get noDeadline => _localizedValues[locale.languageCode]?['noDeadline'] ?? _localizedValues['zh']!['noDeadline']!;
  String get daysLeft => _localizedValues[locale.languageCode]?['daysLeft'] ?? _localizedValues['zh']!['daysLeft']!;
  String get overdue => _localizedValues[locale.languageCode]?['overdue'] ?? _localizedValues['zh']!['overdue']!;

  // 操作
  String get failed => _localizedValues[locale.languageCode]?['failed'] ?? _localizedValues['zh']!['failed']!;
  String get delete => _localizedValues[locale.languageCode]?['delete'] ?? _localizedValues['zh']!['delete']!;
  String get edit => _localizedValues[locale.languageCode]?['edit'] ?? _localizedValues['zh']!['edit']!;

  // 惩罚
  String get punishmentTitle => _localizedValues[locale.languageCode]?['punishmentTitle'] ?? _localizedValues['zh']!['punishmentTitle']!;
  String get goAway => _localizedValues[locale.languageCode]?['goAway'] ?? _localizedValues['zh']!['goAway']!;
  String get reflect => _localizedValues[locale.languageCode]?['reflect'] ?? _localizedValues['zh']!['reflect']!;

  // 教练
  String get selectCoach => _localizedValues[locale.languageCode]?['selectCoach'] ?? _localizedValues['zh']!['selectCoach']!;
  String get unlock => _localizedValues[locale.languageCode]?['unlock'] ?? _localizedValues['zh']!['unlock']!;

  // 统计
  String get statsFlags => _localizedValues[locale.languageCode]?['statsFlags'] ?? _localizedValues['zh']!['statsFlags']!;
  String get statsFails => _localizedValues[locale.languageCode]?['statsFails'] ?? _localizedValues['zh']!['statsFails']!;
  String get statsMaxFails => _localizedValues[locale.languageCode]?['statsMaxFails'] ?? _localizedValues['zh']!['statsMaxFails']!;
  String get statsOverdue => _localizedValues[locale.languageCode]?['statsOverdue'] ?? _localizedValues['zh']!['statsOverdue']!;

  // 成就
  String get achievementsTitle => _localizedValues[locale.languageCode]?['achievementsTitle'] ?? _localizedValues['zh']!['achievementsTitle']!;
  String get achievementsUnlocked => _localizedValues[locale.languageCode]?['achievementsUnlocked'] ?? _localizedValues['zh']!['achievementsUnlocked']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'zh': {
      'appTitle': '今天鸽了吗',
      'homeTitle': '选择你的行刑官',
      'addFlag': '+ 立个Flag (准备打脸)',
      'confirm': '确认作死 (绝不反悔)',
      'cancel': '取消',
      'share': '分享',
      'taskTitle': '任务名称',
      'taskDeadline': '截止日期',
      'noDeadline': '无截止日期',
      'daysLeft': '天后截止',
      'overdue': '已逾期',
      'failed': '鸽了',
      'delete': '删除',
      'edit': '编辑',
      'punishmentTitle': '公开处刑',
      'goAway': '滚吧，下次别再犯了',
      'reflect': '闭嘴，好好反省',
      'selectCoach': '选择你的行刑官',
      'unlock': '解锁',
      'statsFlags': 'Flag数',
      'statsFails': '鸽了次数',
      'statsMaxFails': '最高连鸽',
      'statsOverdue': '已逾期',
      'achievementsTitle': '成就殿堂',
      'achievementsUnlocked': '已解锁',
    },
    'en': {
      'appTitle': 'Did You Flake?',
      'homeTitle': 'Choose Your Judge',
      'addFlag': '+ Set a Flag (Ready to Fail)',
      'confirm': 'Confirm (No Regrets)',
      'cancel': 'Cancel',
      'share': 'Share',
      'taskTitle': 'Task Name',
      'taskDeadline': 'Deadline',
      'noDeadline': 'No Deadline',
      'daysLeft': 'days left',
      'overdue': 'Overdue',
      'failed': 'Flaked',
      'delete': 'Delete',
      'edit': 'Edit',
      'punishmentTitle': 'Public Execution',
      'goAway': 'Go Away, Don\'t Do It Again',
      'reflect': 'Shut Up and Reflect',
      'selectCoach': 'Choose Your Coach',
      'unlock': 'Unlock',
      'statsFlags': 'Flags',
      'statsFails': 'Flakes',
      'statsMaxFails': 'Max Streak',
      'statsOverdue': 'Overdue',
      'achievementsTitle': 'Hall of Shame',
      'achievementsUnlocked': 'Unlocked',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
