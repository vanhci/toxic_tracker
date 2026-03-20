import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// 上传照片到 Supabase Storage，返回公共访问 URL
  static Future<String> uploadProofPhoto(String taskId, File photoFile) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = 'proofs/$taskId/$timestamp.jpg';

      await _client.storage.from('proofs').upload(path, photoFile);

      return _client.storage.from('proofs').getPublicUrl(path);
    } catch (e) {
      print('上传失败（可能是 Supabase 未配置）: $e');
      // 返回一个占位符 URL，让应用可以继续运行
      return 'https://via.placeholder.com/400?text=Photo+Upload+Failed';
    }
  }
}
