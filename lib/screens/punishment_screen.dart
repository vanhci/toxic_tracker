import 'dart:async';
import 'package:flutter/material.dart';

class PunishmentScreen extends StatefulWidget {
  final String punishmentType;
  final String taskTitle;

  const PunishmentScreen({
    super.key,
    required this.punishmentType,
    required this.taskTitle,
  });

  @override
  State<PunishmentScreen> createState() => _PunishmentScreenState();
}

class _PunishmentScreenState extends State<PunishmentScreen> {
  int _countdown = 30; // 30秒的耻辱时刻
  Timer? _timer;
  bool _canExit = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canExit = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 升级为最新的 PopScope API，彻底锁死返回键
    return PopScope(
      canPop: _canExit,
      onPopInvoked: (didPop) {
        if (!didPop) {
          // 这里其实可以加个弹窗骂他：“倒计时没完你点什么返回？”
          // 但为了极简，我们直接无视他的挣扎
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFF3333), // 让人狂躁的刺眼背景红
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 顶部：无情的处刑宣告
                const Column(
                  children: [
                    Text('💀', style: TextStyle(fontSize: 80)),
                    SizedBox(height: 10),
                    Text(
                      '公开处刑',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),

                // 中部：罪名展示 (白底黑框硬阴影)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '连下面这点事都做不到\n你的人生还有什么希望？',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '「${widget.taskTitle}」',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Container(color: Colors.black, height: 4, width: 60), // 极简分割线
                      const SizedBox(height: 16),
                      Text(
                        '当前刑罚：${widget.punishmentType}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFFF3333)),
                      ),
                    ],
                  ),
                ),

                // 下部：绝望的倒计时 (黑底白框反向硬阴影)
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const [BoxShadow(color: Colors.white, offset: Offset(8, 8))],
                  ),
                  child: Center(
                    child: Text(
                      _countdown.toString(),
                      style: const TextStyle(
                        color: Color(0xFFCCFF00), // 荧光黄数字
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                // 底部：极具侮辱性的按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canExit ? () => Navigator.pop(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canExit ? const Color(0xFFCCFF00) : Colors.grey[400],
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey[400],
                      disabledForegroundColor: Colors.black54,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 4)),
                      elevation: 0,
                    ),
                    child: Text(
                      _canExit ? '滚吧，下次别再犯了' : '闭嘴，好好反省 ($_countdown秒)',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
