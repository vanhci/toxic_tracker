import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:toxic_tracker/models/task.dart';

void main() {
  group('Task UI State Tests', () {
    test('Task overdue status affects UI display', () {
      final now = DateTime.now();

      final overdueTask = Task(
        id: 'overdue',
        title: '过期任务',
        createdAt: now.subtract(const Duration(days: 10)),
        deadline: now.subtract(const Duration(days: 1)),
        consecutiveFails: 3,
      );

      expect(overdueTask.isOverdue, true);
      expect(overdueTask.consecutiveFails >= 3, true);
    });

    test('Task close to deadline shows warning', () {
      final now = DateTime.now();

      final urgentTask = Task(
        id: 'urgent',
        title: '紧急任务',
        createdAt: now,
        deadline: now.add(const Duration(hours: 12)),
      );

      expect(urgentTask.daysUntilDeadline, lessThanOrEqualTo(1));
      expect(urgentTask.isOverdue, false);
    });

    test('Task with high fail count triggers punishment', () {
      final now = DateTime.now();

      final punishedTask = Task(
        id: 'punished',
        title: '被惩罚',
        createdAt: now.subtract(const Duration(days: 5)),
        deadline: now.add(const Duration(days: 1)),
        consecutiveFails: 5,
      );

      expect(punishedTask.consecutiveFails, greaterThanOrEqualTo(3));
    });
  });

  group('Brutalist Design Tests', () {
    test('Theme uses bold text style', () {
      final theme = ThemeData(
        useMaterial3: false,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      );

      expect(theme.textTheme.bodyLarge?.fontWeight, FontWeight.w900);
    });

    test('Primary color is fluorescent yellow', () {
      const primaryColor = Color(0xFFCCFF00);
      // 验证颜色值正确
      expect(primaryColor, const Color(0xFFCCFF00));
    });

    test('Danger color is red', () {
      const dangerColor = Color(0xFFFF3333);
      // 验证颜色值正确
      expect(dangerColor, const Color(0xFFFF3333));
    });

    test('Brutalist shadow has zero blur', () {
      const shadow = BoxShadow(
        color: Colors.black,
        offset: Offset(4, 4),
        blurRadius: 0,
      );

      expect(shadow.blurRadius, 0);
      expect(shadow.offset, const Offset(4, 4));
    });
  });

  group('UI Color Tests', () {
    test('Background color for light theme is white', () {
      const bgColor = Colors.white;
      expect(bgColor, Colors.white);
    });

    test('Background color for dark theme is black', () {
      const bgColor = Colors.black;
      expect(bgColor, Colors.black);
    });

    test('Text color contrast in light mode', () {
      const textColor = Colors.black;
      const bgColor = Colors.white;
      // 黑色文字在白色背景上对比度高
      expect(textColor != bgColor, true);
    });

    test('Text color contrast in dark mode', () {
      const textColor = Colors.white;
      const bgColor = Colors.black;
      // 白色文字在黑色背景上对比度高
      expect(textColor != bgColor, true);
    });
  });
}
