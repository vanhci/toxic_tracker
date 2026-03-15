import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ToxicTrackerApp());
}

class ToxicTrackerApp extends StatelessWidget {
  const ToxicTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '今天鸽了吗',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 核心1：关掉 Material 3 默认的软乎乎的圆角和柔和阴影！我们要生硬！
        useMaterial3: false, 
        
        // 核心2：全局强制纯白背景
        scaffoldBackgroundColor: Colors.white, 
        
        // 核心3：注入我们的“发疯”调色盘
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFCCFF00), // 极简亮黄色 (用于主操作按钮)
          secondary: Color(0xFFFF3333), // 刺眼红色 (用于打卡失败和惩罚)
          surface: Colors.white,
          onSurface: Colors.black, // 所有表面的文字强制纯黑
        ),
        
        // 核心4：全局字体变粗，增强压迫感
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
