import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/theme_service.dart';
import 'services/locale_service.dart';
import 'services/notification_service.dart';
import 'services/widget_service.dart';
import 'services/voice_service.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';

final themeService = ThemeService();
final localeService = LocaleService();

class ToxicTrackerApp extends StatefulWidget {
  const ToxicTrackerApp({super.key});

  @override
  State<ToxicTrackerApp> createState() => _ToxicTrackerAppState();
}

class _ToxicTrackerAppState extends State<ToxicTrackerApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    VoiceService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      VoiceService.dispose();
    }
  }

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
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
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
        bodyLarge: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
        bodyMedium: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
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
        bodyLarge: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
        bodyMedium: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 从环境变量读取配置，提供默认值用于开发环境
  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://iyziuawpbpyvwhomtjkh.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_XtedakJDneCB9Lboa4ZhNA_JjTzbaau',
  );

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    print('Supabase 初始化失败（可能是占位符配置）: $e');
  }

  try {
    await Purchases.setLogLevel(LogLevel.debug);
    // 从环境变量读取 API Key，提供默认值用于开发环境
    const appleApiKey = String.fromEnvironment(
      'REVENUECAT_API_KEY',
      defaultValue: 'app5904c87b38',
    );
    final configuration = PurchasesConfiguration(appleApiKey);
    await Purchases.configure(configuration);
  } catch (e) {
    print('RevenueCat 初始化失败: $e');
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

  // 初始化语音服务
  try {
    await VoiceService.initialize();
  } catch (e) {
    print('VoiceService 初始化失败: $e');
  }

  await themeService.load();
  await localeService.load();

  runApp(const ToxicTrackerApp());
}
