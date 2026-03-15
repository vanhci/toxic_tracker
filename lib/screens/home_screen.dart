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

  void _showPunishmentDialog(Task task) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          '⚠️ 惩罚触发',
          style: TextStyle(color: Colors.red, fontSize: 24),
        ),
        content: Text(
          '你已经连续鸽了 ${task.consecutiveFails} 次！\n准备接受惩罚吧！',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          TextButton(
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
            child: const Text(
              '接受惩罚',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        ],
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
      appBar: AppBar(
        title: const Text('今天鸽了吗', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? _buildEmptyState()
              : _buildTaskList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          _loadTasks();
        },
        icon: const Icon(Icons.add),
        label: const Text('新增作死任务'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            '暂无任务',
            style: TextStyle(fontSize: 24, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          Text(
            '点击下方按钮添加你的第一个作死任务',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final isOverdue = task.isOverdue;
    final daysLeft = task.daysUntilDeadline;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: isOverdue ? Colors.red[50] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isOverdue ? Colors.red[900] : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () => _deleteTask(task),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isOverdue ? Icons.warning : Icons.calendar_today,
                  size: 16,
                  color: isOverdue ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  '截止: ${DateFormat('yyyy-MM-dd').format(task.deadline)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  isOverdue
                      ? '已逾期 ${-daysLeft} 天'
                      : '剩余 $daysLeft 天',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (task.consecutiveFails > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '🔥 连续鸽了 ${task.consecutiveFails} 次',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _markAsFailed(task),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  '今天又鸽了',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
