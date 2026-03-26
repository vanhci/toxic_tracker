import 'package:flutter/material.dart';
import '../services/punishment_service.dart';

/// 惩罚记录墙 - 展示所有惩罚历史
class PunishmentHistoryScreen extends StatefulWidget {
  const PunishmentHistoryScreen({super.key});

  @override
  State<PunishmentHistoryScreen> createState() => _PunishmentHistoryScreenState();
}

class _PunishmentHistoryScreenState extends State<PunishmentHistoryScreen> {
  List<PunishmentRecord> _records = [];
  int _totalPunishments = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final records = await PunishmentService.getHistory();
    final total = await PunishmentService.getTotalPunishments();
    setState(() {
      _records = records;
      _totalPunishments = total;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: const Color(0xFFCCFF00),
        title: const Text(
          '💀 惩罚记录墙',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          if (_records.isNotEmpty)
            IconButton(
              onPressed: _confirmClear,
              icon: const Icon(Icons.delete_outline),
              tooltip: '清除记录',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : _records.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😇', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            const Text(
              '清白记录',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            const Text(
              '目前还没有惩罚记录。\n继续保持，别让自己出现在这里。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '累计惩罚次数',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_totalPunishments',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: _totalPunishments > 0
                          ? const Color(0xFFFF3333)
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children: [
        // 统计面板
        _buildStatsPanel(),
        // 记录列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _records.length,
            itemBuilder: (context, index) {
              return _buildRecordCard(_records[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsPanel() {
    // 计算统计
    final levelCounts = <PunishmentLevel, int>{};
    for (final record in _records) {
      levelCounts[record.level] = (levelCounts[record.level] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Color(0xFFCCFF00), width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '💀',
            '$_totalPunishments',
            '累计惩罚',
          ),
          _buildStatItem(
            PunishmentService.getLevelEmoji(PunishmentLevel.heavy),
            '${levelCounts[PunishmentLevel.heavy] ?? 0}',
            '重罚',
          ),
          _buildStatItem(
            PunishmentService.getLevelEmoji(PunishmentLevel.extreme),
            '${levelCounts[PunishmentLevel.extreme] ?? 0}',
            '极刑',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFFCCFF00),
              ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordCard(PunishmentRecord record, int index) {
    final timeAgo = _getTimeAgo(record.timestamp);
    final levelColor = _getLevelColor(record.level);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部：等级 + 时间
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: levelColor,
                  child: Text(
                    '${PunishmentService.getLevelEmoji(record.level)} ${PunishmentService.getLevelDescription(record.level)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 任务标题
            Text(
              '「${record.taskTitle}」',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            // 鸽了次数
            Row(
              children: [
                const Text(
                  '连续鸽了',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.black,
                  child: Text(
                    '${record.failCount} 次',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFCCFF00),
                    ),
                  ),
                ),
              ],
            ),
            // 教练
            if (record.coachName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    record.coachEmoji ?? '🙄',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '处刑官：${record.coachName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
            // 耻辱文案
            if (record.shameText != null && record.shameText!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFFFF9E6),
                child: Text(
                  record.shameText!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            // 惩罚类型
            if (record.types.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: record.types.map((type) => _buildTypeBadge(type)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(PunishmentType type) {
    String emoji;
    String label;
    switch (type) {
      case PunishmentType.verbalWarning:
        emoji = '⚠️';
        label = '口头警告';
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
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Text(
        '$emoji $label',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getLevelColor(PunishmentLevel level) {
    switch (level) {
      case PunishmentLevel.none:
        return Colors.green;
      case PunishmentLevel.light:
        return Colors.orange;
      case PunishmentLevel.medium:
        return const Color(0xFFFF9800);
      case PunishmentLevel.heavy:
        return const Color(0xFFFF5722);
      case PunishmentLevel.extreme:
        return const Color(0xFFFF3333);
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}周前';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}个月前';
    } else {
      return '${(diff.inDays / 365).floor()}年前';
    }
  }

  void _confirmClear() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          '清除记录',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text(
          '确定要清除所有惩罚记录吗？\n这个操作不可撤销。',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              await PunishmentService.clearHistory();
              Navigator.pop(context);
              _loadHistory();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3333),
              foregroundColor: Colors.white,
            ),
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }
}
