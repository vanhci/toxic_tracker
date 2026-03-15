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
  int _countdown = 30;
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
    return WillPopScope(
      onWillPop: () async => _canExit,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red[900]!,
                Colors.black,
                Colors.black,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 100,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      '⚡ 行刑官已降临 ⚡',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '准备受罚！',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '惩罚类型: ${widget.punishmentType}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '任务: ${widget.taskTitle}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 4),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          _countdown.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      _canExit ? '惩罚完成，可以退出' : '惩罚进行中...',
                      style: TextStyle(
                        color: _canExit ? Colors.green : Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _canExit
                            ? () => Navigator.pop(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canExit ? Colors.green : Colors.grey[800],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[800],
                          disabledForegroundColor: Colors.grey[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _canExit ? '逃离地狱' : '惩罚未完成，无法退出',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
