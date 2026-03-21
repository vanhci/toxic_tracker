import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UploadService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// 上传照片到 Supabase Storage，返回公共访问 URL
  static Future<String> uploadProofPhoto(String taskId, XFile photo) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '$taskId/$timestamp.jpg';

      print('开始上传到 Storage: $path');

      // 读取文件字节（跨平台兼容）
      final bytes = await photo.readAsBytes();

      final response = await _client.storage.from('proofs').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          cacheControl: '3600',
          upsert: false,
        ),
      );

      print('上传响应: $response');

      final publicUrl = _client.storage.from('proofs').getPublicUrl(path);
      print('✅ 公共 URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('❌ 上传失败: $e');
      print('❌ 错误类型: ${e.runtimeType}');
      if (e is StorageException) {
        print('❌ Storage 错误: ${e.message}');
        print('❌ Storage 错误码: ${e.error}');
      }
      // 返回占位符 URL，让应用可以继续运行
      return 'https://via.placeholder.com/400?text=Photo+Upload+Failed';
    }
  }
}
