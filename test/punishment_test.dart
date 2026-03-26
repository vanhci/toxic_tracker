import 'package:flutter_test/flutter_test.dart';
import 'package:toxic_tracker/services/punishment_service.dart';
import 'package:toxic_tracker/services/shame_text_service.dart';

void main() {
  group('PunishmentService Tests', () {
    test('Punishment level is correctly determined by fail count', () {
      expect(PunishmentService.getLevel(0), PunishmentLevel.none);
      expect(PunishmentService.getLevel(1), PunishmentLevel.light);
      expect(PunishmentService.getLevel(2), PunishmentLevel.light);
      expect(PunishmentService.getLevel(3), PunishmentLevel.medium);
      expect(PunishmentService.getLevel(5), PunishmentLevel.medium);
      expect(PunishmentService.getLevel(6), PunishmentLevel.heavy);
      expect(PunishmentService.getLevel(10), PunishmentLevel.heavy);
      expect(PunishmentService.getLevel(11), PunishmentLevel.extreme);
      expect(PunishmentService.getLevel(100), PunishmentLevel.extreme);
    });

    test('Punishment level descriptions are correct', () {
      expect(PunishmentService.getLevelDescription(PunishmentLevel.none), '清白');
      expect(PunishmentService.getLevelDescription(PunishmentLevel.light), '口头警告');
      expect(PunishmentService.getLevelDescription(PunishmentLevel.medium), '标准处刑');
      expect(PunishmentService.getLevelDescription(PunishmentLevel.heavy), '重罚伺候');
      expect(PunishmentService.getLevelDescription(PunishmentLevel.extreme), '极刑伺候');
    });

    test('Punishment level emojis are correct', () {
      expect(PunishmentService.getLevelEmoji(PunishmentLevel.none), '😇');
      expect(PunishmentService.getLevelEmoji(PunishmentLevel.light), '⚠️');
      expect(PunishmentService.getLevelEmoji(PunishmentLevel.medium), '💀');
      expect(PunishmentService.getLevelEmoji(PunishmentLevel.heavy), '🔥');
      expect(PunishmentService.getLevelEmoji(PunishmentLevel.extreme), '☠️');
    });

    test('Light punishment has only verbal warning', () {
      const config = PunishmentConfig();
      final types = PunishmentService.getTypesForLevel(PunishmentLevel.light, config);
      expect(types, contains(PunishmentType.verbalWarning));
      expect(types, isNot(contains(PunishmentType.lockScreen)));
      expect(types, isNot(contains(PunishmentType.vibration)));
    });

    test('Medium punishment includes lock screen', () {
      const config = PunishmentConfig();
      final types = PunishmentService.getTypesForLevel(PunishmentLevel.medium, config);
      expect(types, contains(PunishmentType.lockScreen));
      expect(types, contains(PunishmentType.shameCertificate));
    });

    test('Heavy punishment includes vibration and sound', () {
      const config = PunishmentConfig();
      final types = PunishmentService.getTypesForLevel(PunishmentLevel.heavy, config);
      expect(types, contains(PunishmentType.vibration));
      expect(types, contains(PunishmentType.soundEffect));
      expect(types, contains(PunishmentType.annoyingPopup));
    });

    test('Extreme punishment includes all types when enabled', () {
      const config = PunishmentConfig();
      final types = PunishmentService.getTypesForLevel(PunishmentLevel.extreme, config);
      expect(types, contains(PunishmentType.lockScreen));
      expect(types, contains(PunishmentType.vibration));
      expect(types, contains(PunishmentType.soundEffect));
    });

    test('Config can disable specific punishments', () {
      const config = PunishmentConfig(
        enableVibration: false,
        enableSoundEffect: false,
      );
      final types = PunishmentService.getTypesForLevel(PunishmentLevel.heavy, config);
      expect(types, isNot(contains(PunishmentType.vibration)));
      expect(types, isNot(contains(PunishmentType.soundEffect)));
    });

    test('PunishmentConfig serialization works correctly', () {
      const config = PunishmentConfig(
        enableVibration: false,
        enableSoundEffect: true,
        enableScreenFlash: true,
        enableScreenCrack: true,
        enableAnnoyingPopup: false,
        enableShameShare: true,
        lockScreenSeconds: 60,
      );
      
      final json = config.toJson();
      final restored = PunishmentConfig.fromJson(json);
      
      expect(restored.enableVibration, false);
      expect(restored.enableSoundEffect, true);
      expect(restored.enableScreenFlash, true);
      expect(restored.enableScreenCrack, true);
      expect(restored.enableAnnoyingPopup, false);
      expect(restored.enableShameShare, true);
      expect(restored.lockScreenSeconds, 60);
    });

    test('PunishmentRecord serialization works correctly', () {
      final record = PunishmentRecord(
        id: 'test-id',
        taskTitle: 'Test Task',
        failCount: 5,
        level: PunishmentLevel.medium,
        types: [PunishmentType.lockScreen, PunishmentType.screenFlash],
        timestamp: DateTime(2024, 1, 1, 12, 0),
        coachName: 'Test Coach',
        coachEmoji: '🙄',
        shameText: 'Test shame text',
      );
      
      final json = record.toJson();
      final restored = PunishmentRecord.fromJson(json);
      
      expect(restored.id, 'test-id');
      expect(restored.taskTitle, 'Test Task');
      expect(restored.failCount, 5);
      expect(restored.level, PunishmentLevel.medium);
      expect(restored.types, contains(PunishmentType.lockScreen));
      expect(restored.coachName, 'Test Coach');
      expect(restored.shameText, 'Test shame text');
    });
  });

  group('ShameTextService Tests', () {
    test('Generates shame text with placeholders replaced', () {
      final text = ShameTextService.generateShameText(
        taskTitle: 'Exercise',
        failCount: 3,
        coachName: 'Amanda',
        punishmentLevel: 1,
      );
      
      expect(text, isNot(contains('{task}')));
      expect(text, isNot(contains('{count}')));
      expect(text, isNot(contains('{coach}')));
    });

    test('Generates share text with placeholders replaced', () {
      final text = ShameTextService.generateShareText(
        taskTitle: 'Reading',
        failCount: 5,
        coachName: 'Coach',
      );
      
      expect(text, isNot(contains('{task}')));
      expect(text, isNot(contains('{count}')));
      expect(text, isNot(contains('{coach}')));
    });

    test('Generates social death text with placeholders replaced', () {
      final text = ShameTextService.generateSocialDeathText(
        taskTitle: 'Meditation',
        failCount: 10,
      );
      
      expect(text, isNot(contains('{task}')));
      expect(text, isNot(contains('{count}')));
    });

    test('Returns random popup text', () {
      final text = ShameTextService.getRandomPopupText();
      expect(text, isNotEmpty);
      expect(ShameTextService.getAnnoyingPopupTexts(), contains(text));
    });

    test('Coach specific shame text is generated', () {
      final text = ShameTextService.getCoachSpecificShame(
        coachId: 'amanda',
        taskTitle: 'Test',
        failCount: 3,
      );
      expect(text, isNotEmpty);
      
      final text2 = ShameTextService.getCoachSpecificShame(
        coachId: 'slacker_chief',
        taskTitle: 'Test',
        failCount: 3,
      );
      expect(text2, isNotEmpty);
    });
  });
}
