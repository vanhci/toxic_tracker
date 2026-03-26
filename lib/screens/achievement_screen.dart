import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../services/achievement_service.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  List<Achievement> _achievements = [];
  Map<String, int> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final achievements = await AchievementService.loadAchievements();
    final stats = await AchievementService.loadStats();
    setState(() {
      _achievements = achievements;
      _stats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    final totalCount = _achievements.length;
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '🏆 成就系统',
          style: TextStyle(
            color: Color(0xFFCCFF00),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFCCFF00)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFCCFF00),
              ),
            )
          : Column(
              children: [
                // 统计卡片
                _buildStatsCard(unlockedCount, totalCount, progress),
                // 成就列表
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _achievements.length,
                    itemBuilder: (context, index) {
                      return _buildAchievementCard(_achievements[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsCard(int unlocked, int total, double progress) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFFCCFF00), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFFCCFF00), offset: Offset(4, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '成就进度',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$unlocked / $total',
                style: const TextStyle(
                  color: Color(0xFFCCFF00),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFCCFF00)),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 16),
          // 统计数据
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildStatChip('🚩 插旗', _stats['totalFlags'] ?? 0),
              _buildStatChip('🕊️ 鸽子', _stats['totalFails'] ?? 0),
              _buildStatChip('🤝 赦免', _stats['totalPardons'] ?? 0),
              _buildStatChip('⚡ 处刑', _stats['totalExecutions'] ?? 0),
              _buildStatChip('🔥 连胜', _stats['consecutiveNoFail'] ?? 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnlocked ? const Color(0xFF1A1A1A) : Colors.grey[900],
        border: Border.all(
          color: isUnlocked ? const Color(0xFFCCFF00) : Colors.grey[700]!,
          width: 2,
        ),
        boxShadow: isUnlocked
            ? const [BoxShadow(color: Color(0xFFCCFF00), offset: Offset(2, 2))]
            : null,
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isUnlocked ? const Color(0xFFCCFF00) : Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              achievement.emoji,
              style: TextStyle(
                fontSize: 24,
                color: isUnlocked ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
        ),
        title: Text(
          achievement.name,
          style: TextStyle(
            color: isUnlocked ? Colors.white : Colors.grey[500],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: TextStyle(
                color: isUnlocked ? Colors.grey[400] : Colors.grey[600],
                fontSize: 13,
              ),
            ),
            if (isUnlocked && achievement.unlockedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                '解锁于 ${_formatDate(achievement.unlockedAt!)}',
                style: const TextStyle(
                  color: Color(0xFFCCFF00),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        trailing: isUnlocked
            ? const Icon(
                Icons.check_circle,
                color: Color(0xFFCCFF00),
                size: 28,
              )
            : Icon(
                Icons.lock_outline,
                color: Colors.grey[600],
                size: 28,
              ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
