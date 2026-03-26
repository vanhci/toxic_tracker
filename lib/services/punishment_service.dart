import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 惩罚等级
enum PunishmentLevel {
  none,      // 无惩罚
  light,     // 轻罚 (鸽1-2次): 口头警告
  medium,    // 中罚 (鸽3-5次): 30秒锁屏
  heavy,     // 重罚 (鸽6-10次): 震动+音效+锁屏
  extreme,   // 极刑 (鸽10次以上): 全惩罚+社交处刑
}

/// 惩罚类型
enum PunishmentType {
  verbalWarning,    // 口头警告
  lockScreen,       // 锁屏惩罚
  vibration,        // 震动惩罚
  soundEffect,      // 音效惩罚
  screenFlash,      // 屏幕闪烁
  screenCrack,      // 屏幕裂纹效果
  annoyingPopup,    // 弹窗骚扰
  shameShare,       // 社交处刑分享
  shameCertificate, // 耻辱证书
}

/// 惩罚配置 - 用户可自定义开关
class PunishmentConfig {
  final bool enableVibration;
  final bool enableSoundEffect;
  final bool enableScreenFlash;
  final bool enableScreenCrack;
  final bool enableAnnoyingPopup;
  final bool enableShameShare;
  final int lockScreenSeconds;

  const PunishmentConfig({
    this.enableVibration = true,
    this.enableSoundEffect = true,
    this.enableScreenFlash = true,
    this.enableScreenCrack = false, // 默认关闭，可能影响体验
    this.enableAnnoyingPopup = true,
    this.enableShameShare = false,  // 默认关闭，需用户授权
    this.lockScreenSeconds = 30,
  });

  PunishmentConfig copyWith({
    bool? enableVibration,
    bool? enableSoundEffect,
    bool? enableScreenFlash,
    bool? enableScreenCrack,
    bool? enableAnnoyingPopup,
    bool? enableShameShare,
    int? lockScreenSeconds,
  }) {
    return PunishmentConfig(
      enableVibration: enableVibration ?? this.enableVibration,
      enableSoundEffect: enableSoundEffect ?? this.enableSoundEffect,
      enableScreenFlash: enableScreenFlash ?? this.enableScreenFlash,
      enableScreenCrack: enableScreenCrack ?? this.enableScreenCrack,
      enableAnnoyingPopup: enableAnnoyingPopup ?? this.enableAnnoyingPopup,
      enableShameShare: enableShameShare ?? this.enableShameShare,
      lockScreenSeconds: lockScreenSeconds ?? this.lockScreenSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
    'enableVibration': enableVibration,
    'enableSoundEffect': enableSoundEffect,
    'enableScreenFlash': enableScreenFlash,
    'enableScreenCrack': enableScreenCrack,
    'enableAnnoyingPopup': enableAnnoyingPopup,
    'enableShameShare': enableShameShare,
    'lockScreenSeconds': lockScreenSeconds,
  };

  factory PunishmentConfig.fromJson(Map<String, dynamic> json) {
    return PunishmentConfig(
      enableVibration: json['enableVibration'] ?? true,
      enableSoundEffect: json['enableSoundEffect'] ?? true,
      enableScreenFlash: json['enableScreenFlash'] ?? true,
      enableScreenCrack: json['enableScreenCrack'] ?? false,
      enableAnnoyingPopup: json['enableAnnoyingPopup'] ?? true,
      enableShameShare: json['enableShameShare'] ?? false,
      lockScreenSeconds: json['lockScreenSeconds'] ?? 30,
    );
  }
}

/// 惩罚记录
class PunishmentRecord {
  final String id;
  final String taskTitle;
  final int failCount;
  final PunishmentLevel level;
  final List<PunishmentType> types;
  final DateTime timestamp;
  final String? coachName;
  final String? coachEmoji;
  final String? shameText;

  PunishmentRecord({
    required this.id,
    required this.taskTitle,
    required this.failCount,
    required this.level,
    required this.types,
    required this.timestamp,
    this.coachName,
    this.coachEmoji,
    this.shameText,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'taskTitle': taskTitle,
    'failCount': failCount,
    'level': level.index,
    'types': types.map((t) => t.index).toList(),
    'timestamp': timestamp.toIso8601String(),
    'coachName': coachName,
    'coachEmoji': coachEmoji,
    'shameText': shameText,
  };

  factory PunishmentRecord.fromJson(Map<String, dynamic> json) {
    return PunishmentRecord(
      id: json['id'],
      taskTitle: json['taskTitle'],
      failCount: json['failCount'],
      level: PunishmentLevel.values[json['level'] ?? 1],
      types: (json['types'] as List?)
          ?.map((i) => PunishmentType.values[i])
          .toList() ?? [],
      timestamp: DateTime.parse(json['timestamp']),
      coachName: json['coachName'],
      coachEmoji: json['coachEmoji'],
      shameText: json['shameText'],
    );
  }
}

/// 惩罚服务 - 管理惩罚配置和记录
class PunishmentService {
  static const String _configKey = 'punishment_config';
  static const String _recordsKey = 'punishment_records';
  static const String _totalPunishmentsKey = 'total_punishments';

  /// 根据鸽的次数获取惩罚等级
  static PunishmentLevel getLevel(int consecutiveFails) {
    if (consecutiveFails <= 0) return PunishmentLevel.none;
    if (consecutiveFails <= 2) return PunishmentLevel.light;
    if (consecutiveFails <= 5) return PunishmentLevel.medium;
    if (consecutiveFails <= 10) return PunishmentLevel.heavy;
    return PunishmentLevel.extreme;
  }

  /// 根据等级获取惩罚类型列表
  static List<PunishmentType> getTypesForLevel(
    PunishmentLevel level,
    PunishmentConfig config,
  ) {
    switch (level) {
      case PunishmentLevel.none:
        return [];
      case PunishmentLevel.light:
        return [PunishmentType.verbalWarning];
      case PunishmentLevel.medium:
        return [
          PunishmentType.lockScreen,
          if (config.enableScreenFlash) PunishmentType.screenFlash,
          PunishmentType.shameCertificate,
        ];
      case PunishmentLevel.heavy:
        return [
          PunishmentType.lockScreen,
          if (config.enableVibration) PunishmentType.vibration,
          if (config.enableSoundEffect) PunishmentType.soundEffect,
          if (config.enableScreenFlash) PunishmentType.screenFlash,
          if (config.enableScreenCrack) PunishmentType.screenCrack,
          if (config.enableAnnoyingPopup) PunishmentType.annoyingPopup,
          PunishmentType.shameCertificate,
        ];
      case PunishmentLevel.extreme:
        return [
          PunishmentType.lockScreen,
          if (config.enableVibration) PunishmentType.vibration,
          if (config.enableSoundEffect) PunishmentType.soundEffect,
          if (config.enableScreenFlash) PunishmentType.screenFlash,
          if (config.enableScreenCrack) PunishmentType.screenCrack,
          if (config.enableAnnoyingPopup) PunishmentType.annoyingPopup,
          if (config.enableShameShare) PunishmentType.shameShare,
          PunishmentType.shameCertificate,
        ];
    }
  }

  /// 获取惩罚等级描述
  static String getLevelDescription(PunishmentLevel level) {
    switch (level) {
      case PunishmentLevel.none:
        return '清白';
      case PunishmentLevel.light:
        return '口头警告';
      case PunishmentLevel.medium:
        return '标准处刑';
      case PunishmentLevel.heavy:
        return '重罚伺候';
      case PunishmentLevel.extreme:
        return '极刑伺候';
    }
  }

  /// 获取惩罚等级图标
  static String getLevelEmoji(PunishmentLevel level) {
    switch (level) {
      case PunishmentLevel.none:
        return '😇';
      case PunishmentLevel.light:
        return '⚠️';
      case PunishmentLevel.medium:
        return '💀';
      case PunishmentLevel.heavy:
        return '🔥';
      case PunishmentLevel.extreme:
        return '☠️';
    }
  }

  /// 加载惩罚配置
  static Future<PunishmentConfig> loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_configKey);
      if (jsonStr != null) {
        return PunishmentConfig.fromJson(jsonDecode(jsonStr));
      }
    } catch (e) {
      print('加载惩罚配置失败: $e');
    }
    return const PunishmentConfig();
  }

  /// 保存惩罚配置
  static Future<void> saveConfig(PunishmentConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_configKey, jsonEncode(config.toJson()));
    } catch (e) {
      print('保存惩罚配置失败: $e');
    }
  }

  /// 记录惩罚历史
  static Future<void> recordPunishment(PunishmentRecord record) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 获取现有记录
      final recordsJson = prefs.getString(_recordsKey);
      List<dynamic> records = recordsJson != null ? jsonDecode(recordsJson) : [];
      
      // 添加新记录（最多保留50条）
      records.insert(0, record.toJson());
      if (records.length > 50) {
        records = records.sublist(0, 50);
      }
      
      await prefs.setString(_recordsKey, jsonEncode(records));
      
      // 更新总惩罚次数
      final total = prefs.getInt(_totalPunishmentsKey) ?? 0;
      await prefs.setInt(_totalPunishmentsKey, total + 1);
    } catch (e) {
      print('记录惩罚历史失败: $e');
    }
  }

  /// 获取惩罚历史
  static Future<List<PunishmentRecord>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = prefs.getString(_recordsKey);
      if (recordsJson != null) {
        final List<dynamic> records = jsonDecode(recordsJson);
        return records
            .map((r) => PunishmentRecord.fromJson(r))
            .toList();
      }
    } catch (e) {
      print('获取惩罚历史失败: $e');
    }
    return [];
  }

  /// 获取总惩罚次数
  static Future<int> getTotalPunishments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_totalPunishmentsKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// 清除惩罚历史
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recordsKey);
      await prefs.remove(_totalPunishmentsKey);
    } catch (e) {
      print('清除惩罚历史失败: $e');
    }
  }
}
