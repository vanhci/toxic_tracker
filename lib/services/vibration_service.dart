import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// 震动服务 - 提供多种震动模式
class VibrationService {
  static bool _isVibrating = false;

  /// 检查设备是否支持震动
  static Future<bool> hasVibrator() async {
    // 大多数手机都支持震动，这里简化处理
    return true;
  }

  /// 单次震动
  static Future<void> vibrate({int duration = 500}) async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('震动失败: $e');
    }
  }

  /// 轻震动
  static Future<void> lightVibrate() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('轻震动失败: $e');
    }
  }

  /// 中等震动
  static Future<void> mediumVibrate() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('中等震动失败: $e');
    }
  }

  /// 重震动
  static Future<void> heavyVibrate() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('重震动失败: $e');
    }
  }

  /// 错误震动模式 - 连续短震
  static Future<void> errorVibrate() async {
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('错误震动失败: $e');
    }
  }

  /// 警告震动模式 - 长短交替
  static Future<void> warningVibrate() async {
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 300));
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 300));
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('警告震动失败: $e');
    }
  }

  /// 惩罚震动模式 - 持续震动一段时间
  /// [durationSeconds] 震动持续秒数
  /// [interval] 震动间隔毫秒
  static Future<void> punishmentVibrate({
    int durationSeconds = 5,
    int interval = 200,
  }) async {
    if (_isVibrating) return;
    _isVibrating = true;

    try {
      final endTime = DateTime.now().add(Duration(seconds: durationSeconds));
      
      while (DateTime.now().isBefore(endTime) && _isVibrating) {
        await HapticFeedback.heavyImpact();
        await Future.delayed(Duration(milliseconds: interval));
      }
    } catch (e) {
      debugPrint('惩罚震动失败: $e');
    } finally {
      _isVibrating = false;
    }
  }

  /// 停止震动
  static void stopVibrating() {
    _isVibrating = false;
  }

  /// 心跳震动模式
  static Future<void> heartbeatVibrate({int count = 3}) async {
    try {
      for (var i = 0; i < count; i++) {
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 150));
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      debugPrint('心跳震动失败: $e');
    }
  }

  /// SOS 震动模式
  static Future<void> sosVibrate() async {
    try {
      // S: 3短
      for (var i = 0; i < 3; i++) {
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 150));
      }
      await Future.delayed(const Duration(milliseconds: 300));
      // O: 3长
      for (var i = 0; i < 3; i++) {
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 400));
      }
      await Future.delayed(const Duration(milliseconds: 300));
      // S: 3短
      for (var i = 0; i < 3; i++) {
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 150));
      }
    } catch (e) {
      debugPrint('SOS震动失败: $e');
    }
  }
}
