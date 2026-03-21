import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../models/task.dart';
import '../models/coach.dart';
import '../services/task_storage.dart';
import '../services/upload_service.dart';
import '../services/verdict_service.dart';
import '../services/achievement_service.dart';
import '../services/offline_service.dart';
import '../services/widget_service.dart';
import '../main.dart';
import 'add_task_screen.dart';
import 'punishment_screen.dart';
import 'coach_selection_screen.dart';
import 'achievement_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskStorage _storage = TaskStorage();
  final ImagePicker _picker = ImagePicker();
  List<Task> _tasks = [];
  bool _isLoading = true;
  Coach _currentCoach = Coach.defaultCoaches.first;
  // 存储所有活跃的判决 ID，用于取消监听
  final Set<String> _activeVerdictIds = {};
  // 离线状态
  bool _isOnline = true;
  int _pendingUploads = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final online = await OfflineService.isOnline();
    final pending = await OfflineService.getPendingCount();
    setState(() {
      _isOnline = online;
      _pendingUploads = pending;
    });
  }

  @override
  void dispose() {
    for (final verdictId in _activeVerdictIds) {
      VerdictService.cancelListen(verdictId);
    }
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final tasks = await _storage.loadTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
    // 更新小组件数据
    WidgetService.onTaskChanged();
  }

  Future<void> _markAsFailed(Task task) async {
    // 强制拍照作为"呈堂证供"
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 80,
    );

    // 用户拒绝拍照则不记录失败
    if (photo == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('不敢拍？那就别说自己鸽了。', style: TextStyle(fontWeight: FontWeight.w900)),
            backgroundColor: Colors.black,
          ),
        );
      }
      return;
    }

    // 检查网络状态
    final isOnline = await OfflineService.isOnline();

    // 离线模式：保存到本地
    if (!isOnline) {
      final localPath = await OfflineService.savePhotoLocally(task.id, photo);
      if (localPath != null) {
        await OfflineService.addToUploadQueue(
          taskId: task.id,
          taskTitle: task.title,
          localPhotoPath: localPath,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📴 离线模式：照片已保存，联网后自动上传', style: TextStyle(fontWeight: FontWeight.w900)),
              backgroundColor: Color(0xFFFF9800),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      // 即使离线也要记录失败次数
      final now = DateTime.now();
      final updatedTask = task.copyWith(
        consecutiveFails: task.consecutiveFails + 1,
        lastFailDate: now,
      );
      await _storage.updateTask(updatedTask);
      await _loadTasks();
      await AchievementService.updateStats(failsAdded: 1);
      return;
    }

    // 在线模式：上传照片
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('正在上传你的耻辱照片...', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    }

    // 上传照片到 Supabase Storage
    String? photoUrl;
    try {
      photoUrl = await UploadService.uploadProofPhoto(task.id, photo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('上传失败：$e', style: const TextStyle(fontWeight: FontWeight.w900)),
            backgroundColor: const Color(0xFFFF3333),
          ),
        );
      }
      return;
    }

    final now = DateTime.now();
    final updatedTask = task.copyWith(
      consecutiveFails: task.consecutiveFails + 1,
      lastFailDate: now,
    );

    await _storage.updateTask(updatedTask);
    await _loadTasks();

    // 更新成就统计：鸽了次数
    await AchievementService.updateStats(failsAdded: 1);

    // 在 Supabase 创建判决记录，获取 verdictId
    final verdictId = await VerdictService.createVerdict(
      taskId: task.id,
      taskTitle: task.title,
      photoUrl: photoUrl,
    );

    // 监听死党的判决结果
    _activeVerdictIds.add(verdictId);
    VerdictService.listenVerdict(verdictId, (status) {
      VerdictService.cancelListen(verdictId);
      _activeVerdictIds.remove(verdictId);
      if (!mounted) return;
      if (status == VerdictStatus.punish) {
        // 更新成就统计：被处刑
        AchievementService.updateStats(executionsAdded: 1);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PunishmentScreen(
              punishmentType: '死党处刑令',
              taskTitle: task.title,
              failCount: task.consecutiveFails,
              coachName: _currentCoach.name,
              coachEmoji: _currentCoach.emoji,
            ),
          ),
        );
      } else {
        // 更新成就统计：被赦免
        AchievementService.updateStats(pardonsAdded: 1);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('😮‍💨 死党放你一马了，下次别再犯。', style: TextStyle(fontWeight: FontWeight.w900)),
            backgroundColor: Colors.black,
          ),
        );
      }
    });

    // 生成分享链接
    final shareUrl = 'https://judge-self.vercel.app/?verdict=$verdictId&photo=${Uri.encodeComponent(photoUrl)}&task=${Uri.encodeComponent(task.title)}';
    final shareText = '🙄 我又鸽了「${task.title}」\n\n死党们，快来当我的行刑官，帮我做个决定：\n\n$shareUrl\n\n——来自《今天鸽了吗》';

    await Share.share(shareText, subject: '我又鸽了，快来处刑我');

    if (updatedTask.consecutiveFails >= 3) {
      _showPunishmentDialog(updatedTask);
    }
  }

  // 粗野风格的惩罚弹窗
  void _showPunishmentDialog(Task task) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 4),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🙄', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 16),
              const Text(
                '行刑官已就位',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                '你已经连续鸽了 ${task.consecutiveFails} 次！\n你的脸皮可真够厚的。',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PunishmentScreen(
                          punishmentType: '赛博电子木鱼',
                          taskTitle: task.title,
                          failCount: task.consecutiveFails,
                          coachName: _currentCoach.name,
                          coachEmoji: _currentCoach.emoji,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3333), // 刺眼红
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text('接受制裁 (滚去受罚)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteTask(Task task) async {
    await _storage.deleteTask(task.id);
    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildToxicHeader(), // 毒舌教练头部
            if (!_isLoading && _tasks.isNotEmpty) _buildStatsPanel(), // 统计面板
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.black))
                  : _tasks.isEmpty
                      ? _buildEmptyState()
                      : _buildTaskList(),
            ),
            _buildMassiveFab(), // 底部巨大按钮
          ],
        ),
      ),
    );
  }

  // 核心视觉1：抛弃标准AppBar，使用带有强烈个人色彩的Header
  Widget _buildToxicHeader() {
    return GestureDetector(
      onTap: () async {
        final selected = await Navigator.push<Coach>(
          context,
          MaterialPageRoute(builder: (context) => const CoachSelectionScreen()),
        );
        if (selected != null) {
          setState(() => _currentCoach = selected);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
        ),
        child: Row(
          children: [
            Text(_currentCoach.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_currentCoach.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.grey)),
                  Text(_currentCoach.greeting, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, height: 1.2)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black, size: 32),
          ],
        ),
      ),
    );
  }

  // 统计面板：展示鸽了多少次
  Widget _buildStatsPanel() {
    final totalFails = _tasks.fold<int>(0, (sum, t) => sum + t.consecutiveFails);
    final maxFails = _tasks.fold<int>(0, (max, t) => t.consecutiveFails > max ? t.consecutiveFails : max);
    final overdueCount = _tasks.where((t) => t.isOverdue).length;

    return Column(
      children: [
        // 离线状态指示器
        if (!_isOnline || _pendingUploads > 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            color: const Color(0xFFFF9800),
            child: Row(
              children: [
                Icon(_isOnline ? Icons.cloud_upload : Icons.cloud_off, size: 16),
                const SizedBox(width: 8),
                Text(
                  _pendingUploads > 0
                      ? '待上传 $_pendingUploads 张照片'
                      : '离线模式',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFFFF9E6),
            border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('🚩', '${_tasks.length}', 'Flag数'),
                    _buildStatItem('🕊️', '$totalFails', '鸽了次数'),
                    _buildStatItem('💀', '$maxFails', '最高连鸽'),
                    _buildStatItem('⏰', '$overdueCount', '已逾期'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AchievementScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: const Color(0xFFCCFF00),
                  ),
                  child: const Text('🏆', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => themeService.toggle(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.grey[300],
                  ),
                  child: Icon(
                    themeService.isDark ? Icons.light_mode : Icons.dark_mode,
                    size: 20,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => localeService.toggle(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                color: Colors.grey[300],
              ),
              child: Text(
                localeService.locale.languageCode == 'zh' ? '中' : 'EN',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    ),
      ],
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
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          ],
        ),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }

  // 核心视觉2：极具嘲讽意味的空状态
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🗑️', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('真干净啊。', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            SizedBox(height: 10),
            Text('连个Flag都不敢立，你的人生也就这样了吧。赶紧点下面按钮作个死。', 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return _buildBrutalistTaskCard(_tasks[index]);
      },
    );
  }

  // 核心视觉3：粗野主义卡片设计
  Widget _buildBrutalistTaskCard(Task task) {
    final isOverdue = task.isOverdue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isOverdue ? const Color(0xFFFF3333) : Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        // 这里就是灵魂：死板的黑色硬阴影，没有任何模糊
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isOverdue ? Colors.white : Colors.black,
                      height: 1.2,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _deleteTask(task),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                    child: Icon(Icons.close, color: isOverdue ? Colors.white : Colors.black, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (task.consecutiveFails > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.black,
                child: Text(
                  '🔥 已经连续鸽了 ${task.consecutiveFails} 次！',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ),
            // 粗野按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _markAsFailed(task),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: const Text('我颓了 (记一笔)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 核心视觉4：底部通栏的巨大按钮
  Widget _buildMassiveFab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()),
            );
            _loadTasks();
            // 更新成就统计：新增 Flag
            await AchievementService.updateStats(flagsAdded: 1);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCCFF00), // 亮黄色
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
            elevation: 0,
          ).copyWith(
            // 添加按钮的硬阴影效果 (通过 WidgetStateProperty)
            shadowColor: WidgetStateProperty.all(Colors.black),
            elevation: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.pressed) ? 0 : 4),
          ),
          child: const Text('+ 立个Flag (准备打脸)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}
