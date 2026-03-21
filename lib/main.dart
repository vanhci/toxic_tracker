import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/purchase_service.dart';
import 'services/theme_service.dart';
import 'services/locale_service.dart';
import 'services/notification_service.dart';
import 'services/widget_service.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';

final themeService = ThemeService();
final localeService = LocaleService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = 'https://iyziuawpbpyvwhomtjkh.supabase.co';
  const supabaseAnonKey = 'sb_publishable_XtedakJDneCB9Lboa4ZhNA_JjTzbaau';

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    print('Supabase 初始化失败（可能是占位符配置）: $e');
  }

  try {
    await PurchaseService.initialize();
  } catch (e) {
    print('PurchaseService 初始化失败: $e');
  }

  // 初始化通知服务
  try {
    await NotificationService.initialize();
    await NotificationService.requestPermission();
  } catch (e) {
    print('NotificationService 初始化失败: $e');
  }

  // 初始化小组件服务
  try {
    await WidgetService.initialize();
  } catch (e) {
    print('WidgetService 初始化失败: $e');
  }

  await themeService.load();
  await localeService.load();

  runApp(const ToxicTrackerApp());
}

class ToxicTrackerApp extends StatelessWidget {
  const ToxicTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeService, localeService]),
      builder: (context, child) {
        return MaterialApp(
          title: '今天鸽了吗',
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: themeService.mode,
          locale: localeService.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          home: const HomeScreen(),
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFCCFF00),
        secondary: Color(0xFFFF3333),
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFCCFF00),
        secondary: Color(0xFFFF3333),
        surface: Colors.black,
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
