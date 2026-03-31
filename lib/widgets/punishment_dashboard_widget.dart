import 'package:flutter/material.dart';
import '../services/punishment_system_service.dart';

/// 惩罚仪表盘组件
class PunishmentDashboardWidget extends StatefulWidget {
  final VoidCallback? onHistoryTap;
  final VoidCallback? onSettingsTap;

  const PunishmentDashboardWidget({
    super.key,
    this.onHistoryTap,
    this.onSettingsTap,
  });

  @override
  State<PunishmentDashboardWidget> createState() => _PunishmentDashboardWidgetState();
}

class _PunishmentDashboardWidgetState extends State<PunishmentDashboardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  PunishmentDashboard? _dashboard;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _loadDashboard();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    final dashboard = await PunishmentSystemService.getDashboard();
    if (mounted) {
      setState(() {
        _dashboard = dashboard;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_dashboard == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('无法加载惩罚数据'),
        ),
      );
    }

    final tier = _dashboard!.currentTier;
    final tierColor = _parseColor(PunishmentSystemService.getTierColor(tier));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: tier.index > 0 
            ? BorderSide(color: tierColor, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '惩罚仪表盘',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: widget.onHistoryTap,
                      tooltip: '惩罚历史',
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: widget.onSettingsTap,
                      tooltip: '设置',
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 当前等级显示
            ScaleTransition(
              scale: tier.index >= PunishmentTier.tier3.index 
                  ? _pulseAnimation 
                  : const AlwaysStoppedAnimation(1.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: tier.index > 0 
                        ? [tierColor.withOpacity(0.8), tierColor]
                        : [Colors.green.shade300, Colors.green.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: tier.index >= PunishmentTier.tier3.index
                      ? [
                          BoxShadow(
                            color: tierColor.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      PunishmentSystemService.getTierEmoji(tier),
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      PunishmentSystemService.getTierDescription(tier),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (tier.index > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Lv.${_dashboard!.currentLevel}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 统计数据
            Row(
              children: [
                _buildStatCard(
                  '总惩罚',
                  '${_dashboard!.totalPunishments}',
                  Icons.gavel,
                  Colors.red.shade100,
                  Colors.red.shade700,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  '本周',
                  '${_dashboard!.punishmentsThisWeek}',
                  Icons.calendar_today,
                  Colors.orange.shade100,
                  Colors.orange.shade700,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  '本月',
                  '${_dashboard!.punishmentsThisMonth}',
                  Icons.date_range,
                  Colors.purple.shade100,
                  Colors.purple.shade700,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 解锁的惩罚行为
            Text(
              '已解锁惩罚',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dashboard!.unlockedActions
                  .take(6)
                  .map((action) => Chip(
                        label: Text(action.name),
                        avatar: Icon(
                          _getActionIcon(action.id),
                          size: 18,
                        ),
                        backgroundColor: _getTierBackgroundColor(action.tier),
                      ))
                  .toList(),
            ),
            
            // 最近惩罚记录
            if (_dashboard!.recentExecutions.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                '最近惩罚',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...(_dashboard!.recentExecutions.take(3).map((exec) => 
                ListTile(
                  leading: Icon(
                    _getActionIcon(exec.actionId),
                    color: Colors.red.shade400,
                  ),
                  title: Text(exec.taskTitle),
                  subtitle: Text(
                    '失败${exec.failCount}次 · ${_formatTime(exec.startTime)}',
                  ),
                  dense: true,
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color bgColor,
    Color fgColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: fgColor, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: fgColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: fgColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActionIcon(String actionId) {
    switch (actionId) {
      case 'verbal_warning':
        return Icons.warning;
      case 'push_notification':
        return Icons.notifications;
      case 'annoying_popup':
        return Icons.notification_important;
      case 'screen_lock':
        return Icons.lock;
      case 'screen_flash':
        return Icons.flash_on;
      case 'screen_crack':
        return Icons.broken_image;
      case 'shame_poster':
        return Icons.image;
      case 'shame_share':
        return Icons.share;
      case 'shame_certificate':
        return Icons.description;
      case 'wechat_pay':
      case 'alipay_pay':
        return Icons.payment;
      case 'feature_limit':
        return Icons.block;
      case 'avatar_shame':
        return Icons.account_circle;
      default:
        return Icons.gavel;
    }
  }

  Color _getTierBackgroundColor(PunishmentTier tier) {
    switch (tier) {
      case PunishmentTier.none:
        return Colors.green.shade100;
      case PunishmentTier.tier1:
        return Colors.yellow.shade100;
      case PunishmentTier.tier2:
        return Colors.orange.shade100;
      case PunishmentTier.tier3:
        return Colors.red.shade100;
      case PunishmentTier.tier4:
        return Colors.purple.shade100;
      case PunishmentTier.tier5:
        return Colors.grey.shade800;
    }
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${time.month}/${time.day}';
    }
  }
}

/// 惩罚执行动画组件
class PunishmentExecutionWidget extends StatefulWidget {
  final String actionId;
  final String taskTitle;
  final int failCount;
  final String? shameText;
  final VoidCallback? onComplete;

  const PunishmentExecutionWidget({
    super.key,
    required this.actionId,
    required this.taskTitle,
    required this.failCount,
    this.shameText,
    this.onComplete,
  });

  @override
  State<PunishmentExecutionWidget> createState() => _PunishmentExecutionWidgetState();
}

class _PunishmentExecutionWidgetState extends State<PunishmentExecutionWidget>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _scaleController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(_shakeController);
    
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _startAnimations();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _shakeController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.gavel,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              '惩罚执行！',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.taskTitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.shameText != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.shameText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red.shade700,
              ),
              child: const Text('我知错了'),
            ),
          ],
        ),
      ),
    );
  }
}
