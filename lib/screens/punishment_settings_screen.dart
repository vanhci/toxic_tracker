import 'package:flutter/material.dart';
import '../services/punishment_service.dart';

/// 惩罚设置界面 - 用户可自定义惩罚开关
class PunishmentSettingsScreen extends StatefulWidget {
  const PunishmentSettingsScreen({super.key});

  @override
  State<PunishmentSettingsScreen> createState() => _PunishmentSettingsScreenState();
}

class _PunishmentSettingsScreenState extends State<PunishmentSettingsScreen> {
  PunishmentConfig _config = const PunishmentConfig();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await PunishmentService.loadConfig();
    setState(() {
      _config = config;
      _isLoading = false;
    });
  }

  Future<void> _saveConfig() async {
    await PunishmentService.saveConfig(_config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('设置已保存', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: const Color(0xFFCCFF00),
        title: const Text(
          '⚙️ 惩罚设置',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : _buildSettingsList(),
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 说明卡片
        _buildInfoCard(),
        const SizedBox(height: 24),
        // 惩罚效果设置
        _buildSectionTitle('惩罚效果'),
        const SizedBox(height: 12),
        _buildToggleTile(
          '震动惩罚',
          '惩罚时手机持续震动',
          '📳',
          _config.enableVibration,
          (value) {
            setState(() => _config = _config.copyWith(enableVibration: value));
            _saveConfig();
          },
        ),
        _buildToggleTile(
          '音效惩罚',
          '播放尴尬的惩罚音效',
          '🔊',
          _config.enableSoundEffect,
          (value) {
            setState(() => _config = _config.copyWith(enableSoundEffect: value));
            _saveConfig();
          },
        ),
        _buildToggleTile(
          '屏幕闪烁',
          '惩罚时屏幕闪烁效果',
          '💫',
          _config.enableScreenFlash,
          (value) {
            setState(() => _config = _config.copyWith(enableScreenFlash: value));
            _saveConfig();
          },
        ),
        _buildToggleTile(
          '屏幕裂纹',
          '屏幕显示裂纹效果（可能影响体验）',
          '💔',
          _config.enableScreenCrack,
          (value) {
            setState(() => _config = _config.copyWith(enableScreenCrack: value));
            _saveConfig();
          },
        ),
        _buildToggleTile(
          '弹窗骚扰',
          '惩罚期间定时弹出嘲讽弹窗',
          '.popup',
          _config.enableAnnoyingPopup,
          (value) {
            setState(() => _config = _config.copyWith(enableAnnoyingPopup: value));
            _saveConfig();
          },
        ),
        const SizedBox(height: 24),
        // 社交惩罚
        _buildSectionTitle('社交惩罚'),
        const SizedBox(height: 12),
        _buildToggleTile(
          '自动分享',
          '极刑时自动生成社死文案分享（需授权）',
          '📤',
          _config.enableShameShare,
          (value) {
            setState(() => _config = _config.copyWith(enableShameShare: value));
            _saveConfig();
          },
        ),
        const SizedBox(height: 24),
        // 时间设置
        _buildSectionTitle('惩罚时长'),
        const SizedBox(height: 12),
        _buildDurationSlider(),
        const SizedBox(height: 24),
        // 惩罚等级说明
        _buildSectionTitle('惩罚等级说明'),
        const SizedBox(height: 12),
        _buildLevelInfo(),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text(
                '个性化你的惩罚',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '根据你鸽的次数，惩罚会逐渐升级：\n'
            '• 鸽1-2次：轻罚（口头警告）\n'
            '• 鸽3-5次：中罚（锁屏）\n'
            '• 鸽6-10次：重罚（震动+音效+锁屏）\n'
            '• 鸽10次以上：极刑（全惩罚+社死）',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildToggleTile(
    String title,
    String subtitle,
    String emoji,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(2, 2)),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFCCFF00),
        activeTrackColor: Colors.black,
        title: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⏱️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                '锁屏时长',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                color: Colors.black,
                child: Text(
                  '${_config.lockScreenSeconds}秒',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFCCFF00),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.black,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFFCCFF00),
              overlayColor: const Color(0xFFCCFF00).withOpacity(0.2),
              valueIndicatorColor: Colors.black,
              valueIndicatorTextStyle: const TextStyle(
                color: Color(0xFFCCFF00),
                fontWeight: FontWeight.w900,
              ),
            ),
            child: Slider(
              value: _config.lockScreenSeconds.toDouble(),
              min: 10,
              max: 120,
              divisions: 22,
              label: '${_config.lockScreenSeconds}秒',
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(lockScreenSeconds: value.round());
                });
              },
              onChangeEnd: (value) {
                _saveConfig();
              },
            ),
          ),
          const Text(
            '提示：实际惩罚时长会根据惩罚等级调整',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelInfo() {
    return Column(
      children: [
        _buildLevelCard(
          '轻罚',
          '鸽1-2次',
          '口头警告',
          '⚠️',
          Colors.orange,
        ),
        _buildLevelCard(
          '中罚',
          '鸽3-5次',
          '锁屏惩罚',
          '💀',
          const Color(0xFFFF9800),
        ),
        _buildLevelCard(
          '重罚',
          '鸽6-10次',
          '震动+音效+锁屏+弹窗',
          '🔥',
          const Color(0xFFFF5722),
        ),
        _buildLevelCard(
          '极刑',
          '鸽10次以上',
          '全惩罚+社死分享',
          '☠️',
          const Color(0xFFFF3333),
        ),
      ],
    );
  }

  Widget _buildLevelCard(
    String level,
    String condition,
    String effects,
    String emoji,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  condition,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  effects,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
