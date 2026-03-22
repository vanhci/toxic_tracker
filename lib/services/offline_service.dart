import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineService {
  static const String _pendingDir = 'pending_uploads';
  static const String _queueFile = 'upload_queue.json';

  /// 检查网络连接状态
  static Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// 保存照片到本地（离线模式）
  static Future<String?> savePhotoLocally(String taskId, XFile photo) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final pendingDir = Directory('${directory.path}/$_pendingDir/$taskId');

      if (!pendingDir.existsSync()) {
        pendingDir.createSync(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$timestamp.jpg';
      final localPath = '${pendingDir.path}/$fileName';

      // 复制照片到本地
      final bytes = await photo.readAsBytes();
      final file = File(localPath);
      await file.writeAsBytes(bytes);

      print('✅ 照片已保存到本地: $localPath');
      return localPath;
    } catch (e) {
      print('❌ 保存照片失败: $e');
      return null;
    }
  }

  /// 添加待上传记录到队列
  static Future<void> addToUploadQueue({
    required String taskId,
    required String taskTitle,
    required String localPhotoPath,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final queueFile = File('${directory.path}/$_queueFile');

      List<Map<String, dynamic>> queue = [];

      if (queueFile.existsSync()) {
        final content = queueFile.readAsStringSync();
        queue = List<Map<String, dynamic>>.from(jsonDecode(content));
      }

      queue.add({
        'taskId': taskId,
        'taskTitle': taskTitle,
        'localPhotoPath': localPhotoPath,
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'pending',
      });

      await queueFile.writeAsString(jsonEncode(queue));
      print('✅ 已添加到上传队列');
    } catch (e) {
      print('❌ 添加到队列失败: $e');
    }
  }

  /// 获取待上传队列
  static Future<List<Map<String, dynamic>>> getPendingUploads() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final queueFile = File('${directory.path}/$_queueFile');

      if (!queueFile.existsSync()) {
        return [];
      }

      final content = queueFile.readAsStringSync();
      return List<Map<String, dynamic>>.from(jsonDecode(content));
    } catch (e) {
      print('❌ 读取队列失败: $e');
      return [];
    }
  }

  /// 从队列中移除已上传的记录
  static Future<void> removeFromQueue(String localPhotoPath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final queueFile = File('${directory.path}/$_queueFile');

      if (!queueFile.existsSync()) return;

      final content = queueFile.readAsStringSync();
      List<Map<String, dynamic>> queue =
          List<Map<String, dynamic>>.from(jsonDecode(content));

      queue.removeWhere((item) => item['localPhotoPath'] == localPhotoPath);

      await queueFile.writeAsString(jsonEncode(queue));
      print('✅ 已从队列移除');
    } catch (e) {
      print('❌ 移除失败: $e');
    }
  }

  /// 清理本地缓存
  static Future<void> clearLocalCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final pendingDir = Directory('${directory.path}/$_pendingDir');

      if (pendingDir.existsSync()) {
        pendingDir.deleteSync(recursive: true);
      }

      final queueFile = File('${directory.path}/$_queueFile');
      if (queueFile.existsSync()) {
        queueFile.deleteSync();
      }

      print('✅ 本地缓存已清理');
    } catch (e) {
      print('❌ 清理缓存失败: $e');
    }
  }

  /// 获取待上传数量
  static Future<int> getPendingCount() async {
    final queue = await getPendingUploads();
    return queue.where((item) => item['status'] == 'pending').length;
  }
}
