import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/shame_poster_service.dart';
import '../services/shame_text_service.dart';
import '../services/voice_service.dart';
import '../services/vibration_service.dart';
import '../services/sound_service.dart';
import '../services/punishment_service.dart';
import '../models/coach.dart';

class PunishmentScreen extends StatefulWidget {
  final String punishmentType;
  final String taskTitle;
  final int failCount;
  final String? coachName;
  final String? coachEmoji;
  final Coach? coach;
  final PunishmentConfig? config;

  const PunishmentScreen({
    super.key,
    required this.punishmentType,
    required this.taskTitle,
    this.failCount = 3,
    this.coachName,
    this.coachEmoji,
    this.coach,
    this.config,
  });

  @override
  State<PunishmentScreen> createState() => _PunishmentScreenState();
}

class _PunishmentScreenState extends State<PunishmentScreen>
    with TickerProviderStateMixin {
  int _countdown = 30;
  Timer? _timer;
  bool _canExit = false;
  bool _isGeneratingPoster = false;
  
  // 惩罚配置
  late PunishmentConfig _config;
  late PunishmentLevel _level;
  late List<PunishmentType> _types;
  
  // 动画控制器
  late AnimationController _flashController;
  late AnimationController _crackController;
  late AnimationController _shakeController;
  late Animation<double> _flashAnimation;
  
  // 弹窗骚扰
  Timer? _popupTimer;
  int _popupCount = 0;
  
  // 屏幕颜色
  Color _backgroundColor = const Color(0xFFFF3333);
  
  // 耻辱文案
  String _shameText = '';
  
  // 音效是否播放
  bool _soundPlayed = false;

  @override
  void initState() {
    super.initState();
    
    // 初始化配置
    _config = widget.config ?? const PunishmentConfig();
    _level = PunishmentService.getLevel(widget.failCount);
    _types = PunishmentService.getTypesForLevel(_level, _config);
    
    // 根据等级调整倒计时
    _countdown = _getCountdownForLevel(_level);
    
    // 初始化动画控制器
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );
    
    _crackController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    // 启动惩罚
    _startPunishment();
    
    // 生成耻辱文案
    _shameText = ShameTextService.generateShameText(
      taskTitle: widget.taskTitle,
      failCount: widget.failCount,
      coachName: widget.coachName ?? '教练',
      punishmentLevel: _level.index,
    );
    
    // 记录惩罚
    _recordPunishment();
  }

  int _getCountdownForLevel(PunishmentLevel level) {
    switch (level) {
      case PunishmentLevel.none:
        return 0;
      case PunishmentLevel.light:
        return 10;
      case PunishmentLevel.medium:
        return 30;
      case PunishmentLevel.heavy:
        return 45;
      case PunishmentLevel.extreme:
        return 60;
    }
  }

  void _startPunishment() {
    // 播放语音
    _playPunishmentVoice();
    
    // 根据惩罚类型启动效果
    if (_types.contains(PunishmentType.vibration)) {
      VibrationService.punishmentVibrate(
        durationSeconds: _countdown.clamp(3, 10),
        interval: 300,
      );
    }
    
    if (_types.contains(PunishmentType.soundEffect) && !_soundPlayed) {
      _soundPlayed = true;
      SoundService.playForPunishmentLevel(_level.index);
    }
    
    if (_types.contains(PunishmentType.screenFlash)) {
      _startScreenFlash();
    }
    
    if (_types.contains(PunishmentType.annoyingPopup)) {
      _startAnnoyingPopups();
    }
    
    // 开始倒计时
    _startCountdown();
  }

  void _playPunishmentVoice() {
    if (widget.coach != null) {
      VoiceService.playPunishment(widget.coach!, widget.taskTitle);
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
          
          // 屏幕闪烁效果
          if (_types.contains(PunishmentType.screenFlash) && 
              _countdown % 5 == 0) {
            _flashController.forward().then((_) => _flashController.reverse());
          }
          
          // 震动提醒
          if (_types.contains(PunishmentType.vibration) && 
              _countdown <= 10 && _countdown > 0) {
            VibrationService.lightVibrate();
          }
        } else {
          _canExit = true;
          _timer?.cancel();
          _popupTimer?.cancel();
          VibrationService.stopVibrating();
        }
      });
    });
  }

  void _startScreenFlash() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_canExit || !mounted) {
        timer.cancel();
        return;
      }
      _flashController.forward().then((_) => _flashController.reverse());
    });
  }

  void _startAnnoyingPopups() {
    _popupTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_canExit || !mounted) {
        timer.cancel();
        return;
      }
      _showAnnoyingPopup();
    });
  }

  void _showAnnoyingPopup() {
    _popupCount++;
    
    // 震动提醒
    VibrationService.lightVibrate();
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFCCFF00), width: 3),
          borderRadius: BorderRadius.circular(0),
        ),
        title: Text(
          '💀 ${PunishmentService.getLevelEmoji(_level)}',
          style: const TextStyle(color: Color(0xFFCCFF00), fontSize: 32),
          textAlign: TextAlign.center,
        ),
        content: Text(
          ShameTextService.getRandomPopupText(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '继续反省',
              style: TextStyle(
                color: Color(0xFFCCFF00),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _recordPunishment() async {
    final record = PunishmentRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskTitle: widget.taskTitle,
      failCount: widget.failCount,
      level: _level,
      types: _types,
      timestamp: DateTime.now(),
      coachName: widget.coachName,
      coachEmoji: widget.coachEmoji,
      shameText: _shameText,
    );
    await PunishmentService.recordPunishment(record);
  }

  Future<void> _shareShamePoster() async {
    setState(() => _isGeneratingPoster = true);

    try {
      final posterBytes = await ShamePosterService.generatePoster(
        taskTitle: widget.taskTitle,
        failCount: widget.failCount,
        coachName: widget.coachName ?? 'Amanda',
        coachEmoji: widget.coachEmoji ?? '🙄',
        context: context,
      );

      if (posterBytes != null && mounted) {
        await ShamePosterService.sharePoster(posterBytes, widget.taskTitle);
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPoster = false);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _popupTimer?.cancel();
    _flashController.dispose();
    _crackController.dispose();
    _shakeController.dispose();
    VibrationService.stopVibrating();
    SoundService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canExit,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // 无视返回键
          VibrationService.errorVibrate();
        }
      },
      child: AnimatedBuilder(
        animation: _flashAnimation,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: _types.contains(PunishmentType.screenFlash)
                ? _backgroundColor.withOpacity(_flashAnimation.value)
                : _backgroundColor,
            body: Stack(
              children: [
                _buildMainContent(),
                // 屏幕裂纹效果
                if (_types.contains(PunishmentType.screenCrack))
                  _buildCrackOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 顶部：惩罚等级 + 处刑宣告
            _buildHeader(),
            
            // 中部：罪名展示
            _buildCrimeCard(),
            
            // 惩罚等级徽章
            _buildLevelBadge(),
            
            // 倒计时
            _buildCountdown(),
            
            // 底部按钮
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          PunishmentService.getLevelEmoji(_level),
          style: const TextStyle(fontSize: 80),
        ),
        const SizedBox(height: 10),
        Text(
          '${PunishmentService.getLevelDescription(_level)}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),
        if (_types.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              children: _types.map((type) => _buildTypeChip(type)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildTypeChip(PunishmentType type) {
    String emoji;
    String label;
    switch (type) {
      case PunishmentType.verbalWarning:
        emoji = '⚠️';
        label = '警告';
        break;
      case PunishmentType.lockScreen:
        emoji = '🔒';
        label = '锁屏';
        break;
      case PunishmentType.vibration:
        emoji = '📳';
        label = '震动';
        break;
      case PunishmentType.soundEffect:
        emoji = '🔊';
        label = '音效';
        break;
      case PunishmentType.screenFlash:
        emoji = '💫';
        label = '闪烁';
        break;
      case PunishmentType.screenCrack:
        emoji = '💔';
        label = '裂纹';
        break;
      case PunishmentType.annoyingPopup:
        emoji = '.popup';
        label = '弹窗';
        break;
      case PunishmentType.shameShare:
        emoji = '📤';
        label = '社死';
        break;
      case PunishmentType.shameCertificate:
        emoji = '📜';
        label = '证书';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Text(
        '$emoji $label',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCrimeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(8, 8))
        ],
      ),
      child: Column(
        children: [
          Text(
            _shameText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '「${widget.taskTitle}」',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Container(color: Colors.black, height: 4, width: 60),
          const SizedBox(height: 16),
          Text(
            '当前刑罚：${widget.punishmentType}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFF3333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '连续鸽了 ${widget.failCount} 次',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge() {
    if (_level == PunishmentLevel.light) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: const Color(0xFFCCFF00), width: 2),
      ),
      child: Text(
        '惩罚等级：${PunishmentService.getLevelDescription(_level)}',
        style: const TextStyle(
          color: Color(0xFFCCFF00),
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.white, offset: Offset(8, 8))
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 进度环
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: _countdown / _getCountdownForLevel(_level),
              strokeWidth: 8,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFCCFF00)),
            ),
          ),
          // 倒计时数字
          Text(
            _countdown.toString(),
            style: const TextStyle(
              color: Color(0xFFCCFF00),
              fontSize: 72,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        if (_canExit) ...[
          // 分享耻辱海报按钮
          if (_types.contains(PunishmentType.shameCertificate))
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGeneratingPoster ? null : _shareShamePoster,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 4),
                  ),
                  elevation: 0,
                ),
                child: _isGeneratingPoster
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        '📸 分享耻辱证书',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
              ),
            ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canExit ? () => Navigator.pop(context, true) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _canExit ? const Color(0xFFCCFF00) : Colors.grey[400],
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey[400],
              disabledForegroundColor: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 4),
              ),
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
        if (_popupCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '弹窗骚扰：$_popupCount 次',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCrackOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: CrackPainter(progress: _crackController.value),
      ),
    );
  }
}

/// 裂纹绘制器
class CrackPainter extends CustomPainter {
  final double progress;
  final Random _random;

  CrackPainter({required this.progress}) : _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // 从中心向外画多条裂纹
    for (var i = 0; i < 5; i++) {
      final angle = (i * 72 + _random.nextInt(30)) * 3.14159 / 180;
      final startOffset = Offset(size.width / 2, size.height / 2);
      
      _drawCrackLine(
        canvas,
        paint,
        startOffset,
        angle,
        size.shortestSide * 0.4 * progress,
        _random,
      );
    }
  }

  void _drawCrackLine(
    Canvas canvas,
    Paint paint,
    Offset start,
    double angle,
    double length,
    Random random,
  ) {
    if (length < 10) return;

    final end = Offset(
      start.dx + cos(angle) * length,
      start.dy + sin(angle) * length,
    );

    canvas.drawLine(start, end, paint);

    // 递归画分支
    if (length > 20) {
      final branchLength = length * 0.6;
      _drawCrackLine(
        canvas,
        paint,
        end,
        angle + (random.nextDouble() - 0.5) * 0.8,
        branchLength,
        random,
      );
      if (random.nextBool()) {
        _drawCrackLine(
          canvas,
          paint,
          end,
          angle - (random.nextDouble() - 0.5) * 0.8,
          branchLength * 0.8,
          random,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CrackPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
