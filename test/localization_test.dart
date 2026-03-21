import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:toxic_tracker/l10n/app_localizations.dart';

void main() {
  group('AppLocalizations Tests', () {
    test('Supported locales include Chinese and English', () {
      expect(AppLocalizations.supportedLocales.length, 2);
      expect(
        AppLocalizations.supportedLocales.any((l) => l.languageCode == 'zh'),
        true,
      );
      expect(
        AppLocalizations.supportedLocales.any((l) => l.languageCode == 'en'),
        true,
      );
    });

    test('Chinese localizations are correct', () {
      const locale = Locale('zh', 'CN');
      final l10n = AppLocalizations(locale);

      expect(l10n.appTitle, '今天鸽了吗');
      expect(l10n.homeTitle, '选择你的行刑官');
      expect(l10n.addFlag, '+ 立个Flag (准备打脸)');
      expect(l10n.confirm, '确认作死 (绝不反悔)');
      expect(l10n.cancel, '取消');
      expect(l10n.failed, '鸽了');
      expect(l10n.overdue, '已逾期');
      expect(l10n.punishmentTitle, '公开处刑');
      expect(l10n.selectCoach, '选择你的行刑官');
      expect(l10n.achievementsTitle, '成就殿堂');
    });

    test('English localizations are correct', () {
      const locale = Locale('en', 'US');
      final l10n = AppLocalizations(locale);

      expect(l10n.appTitle, 'Did You Flake?');
      expect(l10n.homeTitle, 'Choose Your Judge');
      expect(l10n.addFlag, '+ Set a Flag (Ready to Fail)');
      expect(l10n.confirm, 'Confirm (No Regrets)');
      expect(l10n.cancel, 'Cancel');
      expect(l10n.failed, 'Flaked');
      expect(l10n.overdue, 'Overdue');
      expect(l10n.punishmentTitle, 'Public Execution');
      expect(l10n.selectCoach, 'Choose Your Coach');
      expect(l10n.achievementsTitle, 'Hall of Shame');
    });

    test('Stats labels are localized', () {
      final zhL10n = AppLocalizations(const Locale('zh', 'CN'));
      final enL10n = AppLocalizations(const Locale('en', 'US'));

      // Chinese
      expect(zhL10n.statsFlags, 'Flag数');
      expect(zhL10n.statsFails, '鸽了次数');
      expect(zhL10n.statsMaxFails, '最高连鸽');
      expect(zhL10n.statsOverdue, '已逾期');

      // English
      expect(enL10n.statsFlags, 'Flags');
      expect(enL10n.statsFails, 'Flakes');
      expect(enL10n.statsMaxFails, 'Max Streak');
      expect(enL10n.statsOverdue, 'Overdue');
    });

    test('Task related labels are localized', () {
      final zhL10n = AppLocalizations(const Locale('zh', 'CN'));
      final enL10n = AppLocalizations(const Locale('en', 'US'));

      // Chinese
      expect(zhL10n.taskTitle, '任务名称');
      expect(zhL10n.taskDeadline, '截止日期');
      expect(zhL10n.noDeadline, '无截止日期');
      expect(zhL10n.daysLeft, '天后截止');

      // English
      expect(enL10n.taskTitle, 'Task Name');
      expect(enL10n.taskDeadline, 'Deadline');
      expect(enL10n.noDeadline, 'No Deadline');
      expect(enL10n.daysLeft, 'days left');
    });

    test('Punishment labels are localized', () {
      final zhL10n = AppLocalizations(const Locale('zh', 'CN'));
      final enL10n = AppLocalizations(const Locale('en', 'US'));

      // Chinese
      expect(zhL10n.goAway, '滚吧，下次别再犯了');
      expect(zhL10n.reflect, '闭嘴，好好反省');

      // English
      expect(enL10n.goAway, "Go Away, Don't Do It Again");
      expect(enL10n.reflect, 'Shut Up and Reflect');
    });

    test('Fallback to Chinese for unsupported locale', () {
      final l10n = AppLocalizations(const Locale('fr', 'FR'));
      // Should fallback to Chinese (default)
      expect(l10n.appTitle, '今天鸽了吗');
    });

    test('LocalizationsDelegate is correct', () {
      const delegate = AppLocalizations.delegate;

      expect(delegate.isSupported(const Locale('zh')), true);
      expect(delegate.isSupported(const Locale('en')), true);
      expect(delegate.isSupported(const Locale('fr')), false);
    });

    test('Delegate load returns AppLocalizations', () async {
      const delegate = AppLocalizations.delegate;
      final l10n = await delegate.load(const Locale('zh', 'CN'));

      expect(l10n, isA<AppLocalizations>());
      expect(l10n.appTitle, '今天鸽了吗');
    });

    test('Delegate shouldReload returns false', () {
      const delegate = AppLocalizations.delegate;
      expect(delegate.shouldReload(delegate), false);
    });
  });
}
