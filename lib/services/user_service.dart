import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 用户服务 - 管理用户身份
class UserService {
  static const String _userIdKey = 'user_id';
  static String? _cachedUserId;

  /// 获取或创建用户 ID
  ///
  /// 优先使用 Supabase 匿名用户 ID，
  /// 如果不存在则使用本地生成的唯一 ID
  static Future<String> getUserId() async {
    // 返回缓存的用户 ID
    if (_cachedUserId != null) {
      return _cachedUserId!;
    }

    // 尝试获取 Supabase 匿名用户 ID
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        _cachedUserId = user.id;
        return user.id;
      }

      // 尝试匿名登录
      final authResponse = await supabase.auth.signInAnonymously();
      if (authResponse.user != null) {
        _cachedUserId = authResponse.user!.id;
        return authResponse.user!.id;
      }
    } catch (e) {
      // Supabase 不可用时使用本地 ID
    }

    // 获取或创建本地用户 ID
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString(_userIdKey);

    if (userId == null) {
      // 生成唯一 ID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = DateTime.now().microsecond;
      userId = 'local_${timestamp}_$random';
      await prefs.setString(_userIdKey, userId);
    }

    _cachedUserId = userId;
    return userId;
  }

  /// 清除用户 ID 缓存
  static void clearCache() {
    _cachedUserId = null;
  }

  /// 检查用户是否已登录
  static bool get isAuthenticated {
    try {
      return Supabase.instance.client.auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }
}
