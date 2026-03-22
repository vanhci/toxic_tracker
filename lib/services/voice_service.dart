import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../models/coach.dart';

/// 教练语音服务 - 管理教练语音播放和录制
class VoiceService {
  static final FlutterTts _tts = FlutterTts();
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _initialized = false;

  /// 初始化 TTS
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 设置中文语音
      final languages = await _tts.getLanguages;
      if (languages is List && languages.contains('zh-CN')) {
        await _tts.setLanguage('zh-CN');
      } else if (languages is List && languages.contains('zh')) {
        await _tts.setLanguage('zh');
      }

      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.5);

      _initialized = true;
    } catch (e) {
      debugPrint('TTS 初始化失败: $e');
    }
  }

  /// 播放教练语音
  static Future<void> speak(Coach coach, String message) async {
    try {
      // 优先使用自定义语音
      if (coach.hasCustomVoice) {
        await _playCustomVoice(coach.customVoicePath!);
        return;
      }

      // 其次使用内置语音资源
      if (coach.hasBuiltinVoice) {
        await _audioPlayer.play(AssetSource(coach.voiceAsset!));
        return;
      }

      // 最后使用 TTS
      await _speakWithTTS(coach, message);
    } catch (e) {
      debugPrint('播放语音失败: $e');
    }
  }

  /// 使用 TTS 朗读
  static Future<void> _speakWithTTS(Coach coach, String message) async {
    await _tts.setPitch(coach.voicePitch);
    await _tts.setSpeechRate(coach.voiceRate);
    await _tts.speak(message);
  }

  /// 播放自定义语音文件
  static Future<void> _playCustomVoice(String path) async {
    if (File(path).existsSync()) {
      await _audioPlayer.play(DeviceFileSource(path));
    }
  }

  /// 停止播放
  static Future<void> stop() async {
    await _tts.stop();
    await _audioPlayer.stop();
  }

  /// 录制自定义语音（使用文件选择器选择音频文件）
  static Future<String?> selectCustomVoice() async {
    // 注意：image_picker 主要用于图片，音频选择需要使用 file_picker 包
    // 这里返回 null，实际实现需要使用 file_picker 包
    debugPrint('选择自定义语音文件');
    return null;
  }

  /// 保存自定义语音
  static Future<String?> saveCustomVoice(
      String coachId, String sourcePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final voiceDir = Directory('${directory.path}/coach_voices');
      if (!voiceDir.existsSync()) {
        voiceDir.createSync(recursive: true);
      }

      final targetPath = '${voiceDir.path}/${coachId}_voice.mp3';
      final sourceFile = File(sourcePath);
      if (sourceFile.existsSync()) {
        await sourceFile.copy(targetPath);
        return targetPath;
      }
    } catch (e) {
      debugPrint('保存自定义语音失败: $e');
    }
    return null;
  }

  /// 删除自定义语音
  static Future<void> deleteCustomVoice(String path) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('删除自定义语音失败: $e');
    }
  }

  /// 预览教练语音
  static Future<void> preview(Coach coach) async {
    await speak(coach, coach.greeting);
  }

  /// 播放惩罚语音
  static Future<void> playPunishment(Coach coach, String taskTitle) async {
    final messages = _getPunishmentMessages(coach, taskTitle);
    final message =
        messages[DateTime.now().millisecondsSinceEpoch % messages.length];
    await speak(coach, message);
  }

  /// 获取惩罚消息列表
  static List<String> _getPunishmentMessages(Coach coach, String taskTitle) {
    // 根据教练风格返回不同的惩罚消息
    switch (coach.id) {
      case 'amanda':
        return [
          '「$taskTitle」又鸽了？我早就知道你会这样。',
          '唉，你这自律能力，真是让我头疼。',
          '算了，罚你30秒冷静冷静吧。',
        ];
      case 'slacker_chief':
        return [
          '「$taskTitle」？不做了吧，反正也没人期待。',
          '躺平吧，躺平多舒服啊。',
          '惩罚？不存在的，继续睡吧。',
        ];
      case 'director_wang':
        return [
          '「$taskTitle」这个事情，你的态度很成问题啊。',
          '年轻人，要懂得承担责任。',
          '去，面壁思过30秒。',
        ];
      case 'coach_tie':
        return [
          '「$taskTitle」？你看看你这执行力！',
          '给我去做30个深蹲！不对，是30秒反思！',
          '弱鸡！罚你30秒！',
        ];
      case 'teacher_liu':
        return [
          '「$taskTitle」，你这个任务完成得，比小明还差。',
          '罚你站30秒，好好反省。',
          '全班就你一个人鸽了，丢不丢人？',
        ];
      case 'monk_wu':
        return [
          '「$taskTitle」，施主，放下执念，鸽子也是一种因果。',
          '静坐30秒，观照内心。',
          '阿弥陀佛，罚你冥想30秒。',
        ];
      default:
        return [
          '「$taskTitle」任务失败，接受惩罚吧。',
        ];
    }
  }

  /// 释放资源
  static void dispose() {
    _tts.stop();
    _audioPlayer.dispose();
  }
}
