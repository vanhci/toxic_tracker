import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

class ShamePosterService {
  /// 生成耻辱海报
  static Future<Uint8List?> generatePoster({
    required String taskTitle,
    required int failCount,
    required String coachName,
    required String coachEmoji,
    required BuildContext context,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 背景
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 400, 600), bgPaint);

    // 荧光黄边框
    final borderPaint = Paint()
      ..color = const Color(0xFFCCFF00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawRect(const Rect.fromLTWH(10, 10, 380, 580), borderPaint);

    // 标题
    final titlePainter = TextPainter(
      text: const TextSpan(
        text: '💀 耻辱证书 💀',
        style: TextStyle(
          color: Color(0xFFCCFF00),
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    titlePainter.paint(canvas, Offset((400 - titlePainter.width) / 2, 40));

    // 教练头像区域
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: coachEmoji,
        style: const TextStyle(fontSize: 80),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    emojiPainter.paint(canvas, Offset((400 - emojiPainter.width) / 2, 100));

    // 教练评语
    final coachLabelPainter = TextPainter(
      text: TextSpan(
        text: '$coachName 认证',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    coachLabelPainter.paint(canvas, Offset((400 - coachLabelPainter.width) / 2, 190));

    // 任务标题
    final taskPainter = TextPainter(
      text: TextSpan(
        text: '「$taskTitle」',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: 360);
    taskPainter.paint(canvas, Offset((400 - taskPainter.width) / 2, 250));

    // 鸽了次数
    final failPainter = TextPainter(
      text: TextSpan(
        text: '连续鸽了 $failCount 次',
        style: const TextStyle(
          color: Color(0xFFFF3333),
          fontSize: 36,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    failPainter.paint(canvas, Offset((400 - failPainter.width) / 2, 320));

    // 讽刺文字
    final shamePainter = TextPainter(
      text: const TextSpan(
        text: '特此证明该用户\n在自律这件事上毫无底线',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    shamePainter.paint(canvas, Offset((400 - shamePainter.width) / 2, 390));

    // 二维码占位区域
    final qrPaint = Paint()..color = Colors.white;
    canvas.drawRect(const Rect.fromLTWH(150, 460, 100, 100), qrPaint);

    final qrLabelPainter = TextPainter(
      text: const TextSpan(
        text: '扫码围观',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    qrLabelPainter.paint(canvas, Offset((400 - qrLabelPainter.width) / 2, 570));

    // 生成图片
    final picture = recorder.endRecording();
    final image = await picture.toImage(400, 600);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  /// 分享耻辱海报
  static Future<void> sharePoster(Uint8List posterBytes, String taskTitle) async {
    await Share.shareXFiles(
      [XFile.fromData(posterBytes, name: 'shame_poster.png', mimeType: 'image/png')],
      text: '💀 我因为「$taskTitle」被处刑了，欢迎围观我的耻辱时刻！',
      subject: '我的耻辱证书',
    );
  }
}
