import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_storage.dart';
import 'add_task_screen.dart';
import 'punishment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskStorage _storage = TaskStorage();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final tasks = await _storage.loadTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _markAsFailed(Task task) async {
    final now = DateTime.now();
    final updatedTask = task.copyWith(
      consecutiveFails: task.consecutiveFails + 1,
      lastFailDate: now,
    );

    await _storage.updateTask(updatedTask);
    await _loadTasks();

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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
      ),
      child: const Row(
        children: [
          Text('🙄', style: TextStyle(fontSize: 48)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amanda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.grey)),
                Text('哟，今天准备好\n让我失望了吗？', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, height: 1.2)),
              ],
            ),
          ),
        ],
      ),
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
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCCFF00), // 亮黄色
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
            elevation: 0,
          ).copyWith(
            // 添加按钮的硬阴影效果 (通过 MaterialStateProperty)
            shadowColor: MaterialStateProperty.all(Colors.black),
            elevation: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? 0 : 4),
          ),
          child: const Text('+ 立个Flag (准备打脸)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}
