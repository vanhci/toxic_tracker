import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/achievement_system_service.dart';

/// 成就解锁全屏动画
class AchievementUnlockScreen extends StatefulWidget {
  final AchievementUnlockAnimation animation;
  final VoidCallback? onDismiss;

  const AchievementUnlockScreen({
    super.key,
    required this.animation,
    this.onDismiss,
  });

  @override
  State<AchievementUnlockScreen> createState() => _AchievementUnlockScreenState();
}

class _AchievementUnlockScreenState extends State<AchievementUnlockScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _glowController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: widget.animation.animationDuration,
    );
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.0),
        weight: 40,
      ),
    ]).animate(_mainController);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _mainController.forward();
    
    // 自动关闭
    Future.delayed(widget.animation.animationDuration + const Duration(seconds: 2), () {
      if (mounted) {
        widget.onDismiss?.call();
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = _getRarityColor(widget.animation.rarity);
    
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: GestureDetector(
        onTap: widget.onDismiss,
        child: Stack(
          children: [
            // 粒子背景
            CustomPaint(
              painter: ParticlePainter(
                animation: _particleController,
                color: rarityColor,
              ),
              size: Size.infinite,
            ),
            
            // 主内容
            Center(
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        rarityColor.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: rarityColor,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: rarityColor.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 成就图标
                      AnimatedBuilder(
                        animation: _glowController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: rarityColor.withOpacity(0.2),
                              boxShadow: [
                                BoxShadow(
                                  color: rarityColor.withOpacity(_glowController.value * 0.5),
                                  blurRadius: 20 + _glowController.value * 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(
                              widget.animation.emoji,
                              style: const TextStyle(fontSize: 64),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // 成就解锁文字
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: rarityColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '🎉 成就解锁！',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 成就标题
                      Text(
                        widget.animation.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // 成就描述
                      Text(
                        widget.animation.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      // 奖励列表
                      if (widget.animation.rewards.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 12),
                        Text(
                          '获得奖励',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...widget.animation.rewards.map((reward) => 
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getRewardIcon(reward.type),
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  reward.name,
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // 点击关闭提示
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value * 0.5,
                            child: child,
                          );
                        },
                        child: const Text(
                          '点击任意位置关闭',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRewardIcon(RewardType type) {
    switch (type) {
      case RewardType.voicePack:
        return Icons.record_voice_over;
      case RewardType.title:
        return Icons.military_tech;
      case RewardType.avatarFrame:
        return Icons.account_circle;
      case RewardType.toxicTemplate:
        return Icons.message;
      case RewardType.coachSkin:
        return Icons.face;
      case RewardType.badge:
        return Icons.emoji_events;
    }
  }
}

/// 粒子绘制器
class ParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final List<_Particle> _particles = [];

  ParticlePainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation) {
    // 初始化粒子
    for (int i = 0; i < 50; i++) {
      _particles.add(_Particle(color: color));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in _particles) {
      particle.update(animation.value);
      particle.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  final Color color;
  late double x;
  late double y;
  late double speed;
  late double size;
  late double angle;
  
  _Particle({required this.color}) {
    reset();
  }
  
  void reset() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble() + 1;
    speed = 0.002 + math.Random().nextDouble() * 0.003;
    size = 2 + math.Random().nextDouble() * 4;
    angle = math.Random().nextDouble() * math.pi * 2;
  }
  
  void update(double t) {
    y -= speed;
    x += math.sin(angle + t * math.pi * 2) * 0.001;
    
    if (y < -0.1) {
      reset();
    }
  }
  
  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = this.color.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(x * size.width, y * size.height),
      this.size,
      paint,
    );
  }
}

/// 成就分享卡片
class AchievementShareCardWidget extends StatelessWidget {
  final AchievementShareCard card;

  const AchievementShareCardWidget({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade900,
            Colors.purple.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flag, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              Text(
                'Toxic Tracker',
                style: TextStyle(
                  color: Colors.amber.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 成就图标
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withOpacity(0.2),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Center(
              child: Text(
                card.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 成就标题
          Text(
            card.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // 成就描述
          Text(
            card.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          const Divider(color: Colors.white24),
          
          const SizedBox(height: 12),
          
          // 统计信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('成就', '${card.totalAchievements}'),
              _buildStat('积分', '${card.totalPoints}'),
              _buildStat('日期', '${card.unlockedAt.month}/${card.unlockedAt.day}'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 二维码或下载提示
          Text(
            '扫码加入自律挑战',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// 成就墙组件
class AchievementWallWidget extends StatefulWidget {
  final VoidCallback? onAchievementTap;

  const AchievementWallWidget({
    super.key,
    this.onAchievementTap,
  });

  @override
  State<AchievementWallWidget> createState() => _AchievementWallWidgetState();
}

class _AchievementWallWidgetState extends State<AchievementWallWidget> {
  AchievementWall? _wall;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWall();
  }

  Future<void> _loadWall() async {
    final wall = await AchievementSystemService.getAchievementWall();
    if (mounted) {
      setState(() {
        _wall = wall;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_wall == null) {
      return const Center(child: Text('无法加载成就墙'));
    }

    final achievements = _wall!.achievements
        .where((a) => a.isUnlocked)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题和统计
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '成就墙',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_wall!.unlockedCount}/${_wall!.totalCount}',
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 进度条
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _wall!.completionRate,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 成就网格
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final def = AchievementDefinition.allAchievements.firstWhere(
              (d) => d.id == achievement.achievementId,
              orElse: () => AchievementDefinition.allAchievements.first,
            );
            
            return GestureDetector(
              onTap: widget.onAchievementTap,
              child: Container(
                decoration: BoxDecoration(
                  color: _getRarityColor(def.rarity).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getRarityColor(def.rarity),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    def.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // 积分显示
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade300, Colors.amber.shade600],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  '总积分: ${_wall!.totalPoints}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.amber;
    }
  }
}
