import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  static const String _key = 'locale';
  Locale _locale = const Locale('zh', 'CN');

  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_key);

    if (saved != null) {
      final decoded = jsonDecode(saved) as Map<String, dynamic>;
      _locale = Locale(decoded['languageCode'], decoded['countryCode']);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key,
        jsonEncode({
          'languageCode': locale.languageCode,
          'countryCode': locale.countryCode,
        }));
  }

  Future<void> toggle() async {
    if (_locale.languageCode == 'zh') {
      await setLocale(const Locale('en', 'US'));
    } else {
      await setLocale(const Locale('zh', 'CN'));
    }
  }

  String get languageName => _locale.languageCode == 'zh' ? '中文' : 'English';
}
