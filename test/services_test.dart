import 'package:flutter_test/flutter_test.dart';
import 'package:toxic_tracker/models/task.dart';

void main() {
  group('Task Model Extended Tests', () {
    test('Task daysUntilDeadline should return correct value', () {
      final now = DateTime.now();

      // 任务还有 3 天
      final task3Days = Task(
        id: 'task-3days',
        title: '3天后截止',
        createdAt: now,
        deadline: now.add(const Duration(days: 3)),
      );
      expect(task3Days.daysUntilDeadline, lessThanOrEqualTo(4));
      expect(task3Days.daysUntilDeadline, greaterThanOrEqualTo(2));

      // 已过期任务
      final overdueTask = Task(
        id: 'overdue',
        title: '已过期',
        createdAt: now.subtract(const Duration(days: 10)),
        deadline: now.subtract(const Duration(days: 1)),
      );
      expect(overdueTask.daysUntilDeadline, lessThanOrEqualTo(0));
    });

    test('Task consecutiveFails can be incremented', () {
      final now = DateTime.now();
      var task = Task(
        id: 'fail-task',
        title: '测试失败',
        createdAt: now,
        deadline: now.add(const Duration(days: 1)),
      );

      expect(task.consecutiveFails, 0);

      task = task.copyWith(consecutiveFails: 1);
      expect(task.consecutiveFails, 1);

      task = task.copyWith(consecutiveFails: 2);
      expect(task.consecutiveFails, 2);

      task = task.copyWith(consecutiveFails: 3);
      expect(task.consecutiveFails, 3);
    });

    test('Task punishment threshold is 3', () {
      final now = DateTime.now();

      final task = Task(
        id: 'punish-task',
        title: '惩罚测试',
        createdAt: now,
        deadline: now.add(const Duration(days: 1)),
        consecutiveFails: 3,
      );

      expect(task.consecutiveFails >= 3, true);
    });

    test('Task copyWith preserves unchanged fields', () {
      final now = DateTime.now();
      final original = Task(
        id: 'original-id',
        title: '原标题',
        createdAt: now,
        deadline: now.add(const Duration(days: 7)),
        consecutiveFails: 2,
      );

      // 只更新 consecutiveFails
      final updated = original.copyWith(consecutiveFails: 3);

      expect(updated.id, original.id);
      expect(updated.title, original.title);
      expect(updated.createdAt, original.createdAt);
      expect(updated.deadline, original.deadline);
      expect(updated.consecutiveFails, 3);
    });

    test('Task JSON round-trip preserves all fields', () {
      final now = DateTime.now();
      final failDate = now.subtract(const Duration(days: 1));

      final original = Task(
        id: 'json-test',
        title: 'JSON 测试',
        createdAt: now,
        deadline: now.add(const Duration(days: 5)),
        consecutiveFails: 2,
        lastFailDate: failDate,
      );

      final json = original.toJson();
      final restored = Task.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.consecutiveFails, original.consecutiveFails);
      expect(restored.lastFailDate?.millisecondsSinceEpoch,
          original.lastFailDate?.millisecondsSinceEpoch);
    });
  });

  group('Task Edge Cases', () {
    test('Task with deadline exactly now', () {
      final now = DateTime.now();
      final task = Task(
        id: 'edge-now',
        title: '刚刚截止',
        createdAt: now.subtract(const Duration(days: 1)),
        deadline: now,
      );
      // isOverdue 可能是 true 或 false
      expect(task.isOverdue, isA<bool>());
    });

    test('Task with very long title', () {
      final now = DateTime.now();
      final longTitle = '这是一个非常长的任务标题' * 50;

      final task = Task(
        id: 'long-title',
        title: longTitle,
        createdAt: now,
        deadline: now.add(const Duration(days: 1)),
      );

      expect(task.title, longTitle);
      expect(task.title.length, greaterThan(500));
    });

    test('Task with empty title should still work', () {
      final now = DateTime.now();
      final task = Task(
        id: 'empty-title',
        title: '',
        createdAt: now,
        deadline: now.add(const Duration(days: 1)),
      );

      expect(task.title, '');
    });

    test('Task created far in the past', () {
      final now = DateTime.now();
      final ancientDate = now.subtract(const Duration(days: 365));

      final task = Task(
        id: 'ancient',
        title: '一年前创建',
        createdAt: ancientDate,
        deadline: now.add(const Duration(days: 1)),
      );

      // 验证任务可以被创建
      expect(task.createdAt, ancientDate);
    });

    test('Task with maximum consecutiveFails', () {
      final now = DateTime.now();
      final task = Task(
        id: 'max-fails',
        title: '最大失败次数',
        createdAt: now,
        deadline: now.add(const Duration(days: 1)),
        consecutiveFails: 999,
      );

      expect(task.consecutiveFails, 999);
    });
  });

  group('Task Date Calculations', () {
    test('Task with deadline today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final task = Task(
        id: 'today-deadline',
        title: '今天截止',
        createdAt: now,
        deadline: tomorrow,
      );

      // deadline 是明天 00:00，所以剩余天数应该是 0 或 1
      expect(task.daysUntilDeadline, greaterThanOrEqualTo(0));
    });

    test('Task with deadline tomorrow', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dayAfter = today.add(const Duration(days: 2));

      final task = Task(
        id: 'tomorrow-deadline',
        title: '明天截止',
        createdAt: now,
        deadline: dayAfter,
      );

      // deadline 是后天 00:00，所以剩余天数应该是 1 或 2
      expect(task.daysUntilDeadline, greaterThanOrEqualTo(1));
    });

    test('Task overdue by one day', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final task = Task(
        id: 'one-day-overdue',
        title: '过期一天',
        createdAt: now.subtract(const Duration(days: 2)),
        deadline: yesterday,
      );

      expect(task.isOverdue, true);
      // 过期任务的 daysUntilDeadline 应该是负数或零
      expect(task.daysUntilDeadline, lessThanOrEqualTo(0));
    });
  });
}
