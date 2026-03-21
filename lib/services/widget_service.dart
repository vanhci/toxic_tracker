import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'task_storage.dart';

/// 小组件服务 - 管理 iOS/Android 桌面小组件数据
class WidgetService {
  static const String _widgetAndroid = 'ToxicTrackerWidgetProvider';
  static const String _widgetIOS = 'ToxicTrackerWidget';

  /// 初始化小组件回调
  static Future<void> initialize() async {
    // 监听小组件点击事件
    HomeWidget.widgetClicked.listen((uri) {
      if (uri != null) {
        _handleWidgetClick(uri);
      }
    });

    // 初始更新
    await updateWidget();
  }

  /// 处理小组件点击
  static void _handleWidgetClick(Uri uri) {
    // 小组件点击后打开 App
    debugPrint('小组件被点击: $uri');
  }

  /// 更新小组件数据
  static Future<void> updateWidget() async {
    try {
      final storage = TaskStorage();
      final tasks = await storage.loadTasks();

      // 统计数据
      final overdueTasks = tasks.where((t) => t.isOverdue).toList();
      final totalFails = tasks.fold<int>(0, (sum, t) => sum + t.consecutiveFails);

      // 鸽王称号
      String title = '今天鸽了吗？';
      String subtitle = '';
      String emoji = '🙄';

      if (totalFails >= 10) {
        title = '鸽王之王';
        subtitle = '已累计鸽了 $totalFails 次';
        emoji = '👑';
      } else if (totalFails >= 5) {
        title = '资深鸽手';
        subtitle = '已累计鸽了 $totalFails 次';
        emoji = '🐦';
      } else if (overdueTasks.isNotEmpty) {
        title = '有 ${overdueTasks.length} 个任务逾期';
        subtitle = '快点去完成吧！';
        emoji = '💀';
      } else if (tasks.isNotEmpty) {
        title = '还有 ${tasks.length} 个任务';
        subtitle = '今天也要加油哦';
        emoji = '💪';
      } else {
        title = '还没有任务';
        subtitle = '快去添加一个吧';
        emoji = '🎯';
      }

      // 保存数据到小组件
      await HomeWidget.saveWidgetData('widget_title', title);
      await HomeWidget.saveWidgetData('widget_subtitle', subtitle);
      await HomeWidget.saveWidgetData('widget_emoji', emoji);
      await HomeWidget.saveWidgetData('task_count', tasks.length);
      await HomeWidget.saveWidgetData('overdue_count', overdueTasks.length);
      await HomeWidget.saveWidgetData('total_fails', totalFails);

      // 更新小组件显示
      await HomeWidget.updateWidget(
        androidName: _widgetAndroid,
        iOSName: _widgetIOS,
      );
    } catch (e) {
      debugPrint('更新小组件失败: $e');
    }
  }

  /// 任务变更后更新小组件
  static Future<void> onTaskChanged() async {
    await updateWidget();
  }

  /// 获取小组件背景颜色（粗野主义风格）
  static Color getWidgetBackgroundColor(bool isDark) {
    return isDark ? Colors.black : Colors.white;
  }

  /// 获取小组件强调色
  static Color getWidgetAccentColor() {
    return const Color(0xFFCCFF00); // 荧光黄
  }
}
