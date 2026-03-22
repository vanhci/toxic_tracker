import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

enum VerdictStatus { pending, pass, punish }

class VerdictService {
  static SupabaseClient get _client => Supabase.instance.client;
  static final Map<String, Timer> _timers = {};

  /// 创建一条待判决记录，返回 verdictId
  static Future<String> createVerdict({
    required String taskId,
    required String taskTitle,
    required String photoUrl,
  }) async {
    try {
      final response = await _client
          .from('verdicts')
          .insert({
            'task_id': taskId,
            'task_title': taskTitle,
            'photo_url': photoUrl,
            'status': 'pending',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      print('创建判决记录失败（可能是 Supabase 未配置）: $e');
      // 返回一个假的 verdictId，让应用可以继续运行
      return 'dev-verdict-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// 轮询监听判决状态变化（每2秒检查一次）
  static void listenVerdict(
    String verdictId,
    void Function(VerdictStatus) onStatusChange,
  ) {
    _timers[verdictId]?.cancel();

    _timers[verdictId] =
        Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final response = await _client
            .from('verdicts')
            .select('status')
            .eq('id', verdictId)
            .single();

        final status = response['status'] as String?;
        if (status == 'pass') {
          timer.cancel();
          _timers.remove(verdictId);
          onStatusChange(VerdictStatus.pass);
        } else if (status == 'punish') {
          timer.cancel();
          _timers.remove(verdictId);
          onStatusChange(VerdictStatus.punish);
        }
      } catch (e) {
        // 查询失败，停止轮询
        print('查询判决状态失败（可能是 Supabase 未配置）: $e');
        timer.cancel();
        _timers.remove(verdictId);
      }
    });
  }

  /// 取消监听
  static void cancelListen(String verdictId) {
    _timers[verdictId]?.cancel();
    _timers.remove(verdictId);
  }
}
