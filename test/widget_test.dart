import 'package:flutter_test/flutter_test.dart';
import 'package:toxic_tracker/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task should be created with correct properties', () {
      final now = DateTime.now();
      final deadline = now.add(const Duration(days: 7));

      final task = Task(
        id: 'test-id',
        title: '测试任务',
        createdAt: now,
        deadline: deadline,
      );

      expect(task.id, 'test-id');
      expect(task.title, '测试任务');
      expect(task.consecutiveFails, 0);
      expect(task.lastFailDate, isNull);
    });

    test('Task copyWith should update properties correctly', () {
      final now = DateTime.now();
      final deadline = now.add(const Duration(days: 7));

      final task = Task(
        id: 'test-id',
        title: '测试任务',
        createdAt: now,
        deadline: deadline,
      );

      final failDate = DateTime.now();
      final updatedTask = task.copyWith(
        consecutiveFails: 3,
        lastFailDate: failDate,
      );

      expect(updatedTask.consecutiveFails, 3);
      expect(updatedTask.lastFailDate, failDate);
      expect(updatedTask.id, task.id);
      expect(updatedTask.title, task.title);
    });

    test('Task JSON serialization should work correctly', () {
      final now = DateTime.now();
      final deadline = now.add(const Duration(days: 7));

      final task = Task(
        id: 'test-id',
        title: '测试任务',
        createdAt: now,
        deadline: deadline,
        consecutiveFails: 2,
      );

      final json = task.toJson();
      final restoredTask = Task.fromJson(json);

      expect(restoredTask.id, task.id);
      expect(restoredTask.title, task.title);
      expect(restoredTask.consecutiveFails, task.consecutiveFails);
    });

    test('Task isOverdue should return correct value', () {
      final now = DateTime.now();

      // 过期任务
      final overdueTask = Task(
        id: 'overdue',
        title: '过期任务',
        createdAt: now.subtract(const Duration(days: 10)),
        deadline: now.subtract(const Duration(days: 1)),
      );
      expect(overdueTask.isOverdue, true);

      // 未过期任务
      final futureTask = Task(
        id: 'future',
        title: '未来任务',
        createdAt: now,
        deadline: now.add(const Duration(days: 7)),
      );
      expect(futureTask.isOverdue, false);
    });
  });
}
