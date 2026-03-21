import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _key = 'theme_mode';
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_key);

    if (saved != null) {
      final index = jsonDecode(saved) as int;
      _mode = ThemeMode.values[index];
      notifyListeners();
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(mode.index));
  }

  Future<void> toggle() async {
    if (_mode == ThemeMode.light) {
      await setMode(ThemeMode.dark);
    } else {
      await setMode(ThemeMode.light);
    }
  }
}
