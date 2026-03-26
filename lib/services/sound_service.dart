import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

/// 音效类型枚举
enum SoundType {
  scream,        // 尖叫
  sadTrombone,   // 沮丧的长号
  buzzer,        // 蜂鸣器
  fail,          // 失败音效
  boo,           // 嘘声
  laugh,         // 嘲笑
  gong,          // 锣声
  siren,         // 警报
  explosion,     // 爆炸
  cry,           // 哭声
}

/// 音效服务 - 播放各种惩罚音效
class SoundService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;

  /// 获取音效文件路径
  static String _getSoundPath(SoundType type) {
    // 这些是占位符路径，实际需要添加音频资源
    switch (type) {
      case SoundType.scream:
        return 'sounds/scream.mp3';
      case SoundType.sadTrombone:
        return 'sounds/sad_trombone.mp3';
      case SoundType.buzzer:
        return 'sounds/buzzer.mp3';
      case SoundType.fail:
        return 'sounds/fail.mp3';
      case SoundType.boo:
        return 'sounds/boo.mp3';
      case SoundType.laugh:
        return 'sounds/laugh.mp3';
      case SoundType.gong:
        return 'sounds/gong.mp3';
      case SoundType.siren:
        return 'sounds/siren.mp3';
      case SoundType.explosion:
        return 'sounds/explosion.mp3';
      case SoundType.cry:
        return 'sounds/cry.mp3';
    }
  }

  /// 播放音效
  static Future<void> play(SoundType type, {double volume = 1.0}) async {
    if (_isPlaying) return;
    
    try {
      _isPlaying = true;
      await _audioPlayer.setVolume(volume);
      
      // 尝试播放内置音效，如果失败则使用系统音
      try {
        await _audioPlayer.play(AssetSource(_getSoundPath(type)));
      } catch (e) {
        debugPrint('内置音效加载失败，使用系统反馈: $e');
        // 音效文件不存在时，我们可以使用震动作为替代反馈
      }
    } catch (e) {
      debugPrint('播放音效失败: $e');
    } finally {
      // 等待音效播放完成
      await Future.delayed(const Duration(seconds: 2));
      _isPlaying = false;
    }
  }

  /// 停止播放
  static Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('停止音效失败: $e');
    }
  }

  /// 释放资源
  static void dispose() {
    _audioPlayer.dispose();
  }

  /// 随机播放一个惩罚音效
  static Future<void> playRandom({double volume = 1.0}) async {
    final random = Random();
    final types = SoundType.values;
    final randomType = types[random.nextInt(types.length)];
    await play(randomType, volume: volume);
  }

  /// 播放失败音效序列
  static Future<void> playFailSequence() async {
    try {
      _isPlaying = true;
      // 先播放失败音效
      await play(SoundType.fail, volume: 0.8);
      await Future.delayed(const Duration(milliseconds: 500));
      // 然后播放嘲笑
      await play(SoundType.laugh, volume: 0.6);
    } catch (e) {
      debugPrint('播放失败序列失败: $e');
    } finally {
      _isPlaying = false;
    }
  }

  /// 播放惩罚音效序列
  static Future<void> playPunishmentSequence() async {
    try {
      _isPlaying = true;
      // 警报声开场
      await play(SoundType.siren, volume: 0.7);
      await Future.delayed(const Duration(milliseconds: 800));
      // 锣声宣告
      await play(SoundType.gong, volume: 0.9);
      await Future.delayed(const Duration(milliseconds: 500));
      // 尖叫收尾
      await play(SoundType.scream, volume: 0.6);
    } catch (e) {
      debugPrint('播放惩罚序列失败: $e');
    } finally {
      _isPlaying = false;
    }
  }

  /// 根据惩罚等级播放对应音效
  static Future<void> playForPunishmentLevel(int level) async {
    switch (level) {
      case 1: // 轻罚
        await play(SoundType.buzzer, volume: 0.5);
        break;
      case 2: // 中罚
        await play(SoundType.fail, volume: 0.7);
        break;
      case 3: // 重罚
        await playFailSequence();
        break;
      case 4: // 极刑
        await playPunishmentSequence();
        break;
      default:
        await play(SoundType.buzzer, volume: 0.3);
    }
  }
}
