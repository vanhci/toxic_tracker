import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_storage.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final TaskStorage _storage = TaskStorage();
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      // 强行把原生系统日历的颜色改成刺眼的红黑配
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // 头部背景色
              onPrimary: Colors.white, // 头部文字色
              onSurface: Colors.black, // 日期文字色
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        createdAt: DateTime.now(),
        deadline: _selectedDeadline,
      );

      await _storage.addTask(task);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildBrutalistHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '你要立什么Flag？',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      _buildBrutalistTextField(),
                      const SizedBox(height: 40),
                      const Text(
                        '死期 (截止日期)',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      _buildBrutalistDatePicker(),
                      const SizedBox(height: 60),
                      _buildSaveButton(),
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

  // 核心视觉1：粗野主义头部 (干掉原生 AppBar)
  Widget _buildBrutalistHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0)],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            '签生死状',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // 核心视觉2：巨大且极具压迫感的输入框
  Widget _buildBrutalistTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0)],
      ),
      child: TextFormField(
        controller: _titleController,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        maxLines: 3, // 让输入框变大，更有存在感
        minLines: 1,
        decoration: const InputDecoration(
          hintText: '说吧，今天又想假装努力做什么？\n(例如：绝不喝奶茶)',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.normal),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '怎么，连字都不敢打了？'; // 毒舌校验提示
          }
          return null;
        },
      ),
    );
  }

  // 核心视觉3：粗野主义日期选择器触发按钮
  Widget _buildBrutalistDatePicker() {
    return GestureDetector(
      onTap: _selectDeadline,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFCCFF00), // 亮黄色背景
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0)],
        ),
        child: Row(
          children: [
            const Text('🗓️', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Text(
              '${_selectedDeadline.year}年${_selectedDeadline.month}月${_selectedDeadline.day}日',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black),
            ),
            const Spacer(),
            const Icon(Icons.edit, color: Colors.black, size: 28),
          ],
        ),
      ),
    );
  }

  // 核心视觉4：极简黑白高对比提交按钮
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // 全黑底色，凸显决绝感
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
          elevation: 0,
        ).copyWith(
          // 点击时硬阴影消失的交互反馈
          elevation: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? 0 : 0),
        ),
        child: const Text(
          '确认作死 (绝不反悔)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
    );
  }
}
