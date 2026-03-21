import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// 通知服务 - 管理本地推送通知
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// 初始化通知服务
  static Future<void> initialize() async {
    if (_initialized) return;

    // 初始化时区
    tz_data.initializeTimeZones();

    // Android 设置
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 设置
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// 通知点击回调
  static void _onNotificationTapped(NotificationResponse response) {
    // 可以在这里处理通知点击事件
    print('通知被点击: ${response.payload}');
  }

  /// 请求通知权限
  static Future<bool> requestPermission() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    bool granted = true;

    if (android != null) {
      final androidGranted = await android.requestNotificationsPermission();
      granted &= androidGranted ?? false;
    }

    if (ios != null) {
      final iosGranted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted &= iosGranted ?? false;
    }

    return granted;
  }

  /// 立即发送通知
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'toxic_tracker',
      '今天鸽了吗',
      channelDescription: '任务提醒和处刑通知',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// 定时通知
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'toxic_tracker_scheduled',
      '定时提醒',
      channelDescription: '任务截止日期提醒',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// 取消通知
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// 取消所有通知
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// 发送"该做事了"提醒
  static Future<void> remindTask(String taskTitle, int taskId) async {
    await showNotification(
      id: taskId.hashCode,
      title: '⏰ 该做事了！',
      body: '「$taskTitle」的截止时间快到了，别再鸽了！',
      payload: 'task:$taskId',
    );
  }

  /// 发送"已经逾期"警告
  static Future<void> warnOverdue(String taskTitle, int taskId) async {
    await showNotification(
      id: taskId.hashCode + 1000,
      title: '💀 已经逾期了！',
      body: '「$taskTitle」已经超过截止日期，快去补救吧！',
      payload: 'task:$taskId',
    );
  }

  /// 发送处刑通知
  static Future<void> notifyPunishment(String taskTitle) async {
    await showNotification(
      id: 999999,
      title: '🔥 处刑令已下达',
      body: '你的死党已经判决「$taskTitle」立刻处刑，打开 App 接受惩罚吧！',
      payload: 'punishment',
    );
  }

  /// 设置截止日期提醒（提前 1 小时）
  static Future<void> scheduleDeadlineReminder({
    required String taskTitle,
    required int taskId,
    required DateTime deadline,
  }) async {
    // 提前 1 小时提醒
    final reminderTime = deadline.subtract(const Duration(hours: 1));

    if (reminderTime.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: taskId.hashCode + 5000,
        title: '⏰ 最后 1 小时！',
        body: '「$taskTitle」将在 1 小时后截止，抓紧时间！',
        scheduledDate: reminderTime,
        payload: 'task:$taskId',
      );
    }
  }
}
