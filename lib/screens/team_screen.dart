import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/team.dart';
import '../services/team_service.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  Team? _team;
  bool _isLoading = true;
  bool _isCreating = false;
  final _teamNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _displayNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _inviteCodeController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _loadTeam() async {
    setState(() => _isLoading = true);
    final team = await TeamService.getCurrentTeam();
    setState(() {
      _team = team;
      _isLoading = false;
    });
  }

  Future<void> _createTeam() async {
    if (_teamNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入团队名称', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Color(0xFFFF3333),
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    // TODO: 获取真实用户 ID
    final team = await TeamService.createTeam(
      name: _teamNameController.text,
      leaderId: 'demo_user',
      leaderName: _displayNameController.text.isNotEmpty
          ? _displayNameController.text
          : '队长',
    );

    setState(() => _isCreating = false);

    if (team != null) {
      Navigator.pop(context);
      setState(() => _team = team);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 团队创建成功！', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Color(0xFFCCFF00),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('创建失败，请稍后重试', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Color(0xFFFF3333),
        ),
      );
    }
  }

  Future<void> _joinTeam() async {
    if (_inviteCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入邀请码', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Color(0xFFFF3333),
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    final team = await TeamService.joinTeam(
      inviteCode: _inviteCodeController.text,
      userId: 'demo_user',
      displayName: _displayNameController.text.isNotEmpty
          ? _displayNameController.text
          : '新成员',
    );

    setState(() => _isCreating = false);

    if (team != null) {
      Navigator.pop(context);
      setState(() => _team = team);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 加入团队成功！', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Color(0xFFCCFF00),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('邀请码无效或已过期', style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Color(0xFFFF3333),
        ),
      );
    }
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏢', style: TextStyle(fontSize: 50)),
                const SizedBox(height: 12),
                const Text(
                  '创建团队',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _teamNameController,
                  decoration: const InputDecoration(
                    labelText: '团队名称',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: '你的昵称',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _createTeam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCCFF00),
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('创建', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showJoinDialog() {
    showDialog(
      context: context,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🤝', style: TextStyle(fontSize: 50)),
                const SizedBox(height: 12),
                const Text(
                  '加入团队',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _inviteCodeController,
                  decoration: const InputDecoration(
                    labelText: '邀请码',
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 8),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: '你的昵称',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _joinTeam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCCFF00),
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('加入', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : _team == null
                ? _buildNoTeamView()
                : _buildTeamView(),
      ),
    );
  }

  Widget _buildNoTeamView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏢', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 24),
          const Text(
            '还没有团队',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          const Text(
            '创建一个团队，邀请你的朋友一起互相监督吧！',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showCreateDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCCFF00),
                foregroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 3),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('创建团队', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showJoinDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 3),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('加入团队', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(height: 40),
          // 企业版说明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Column(
              children: [
                Text('💼 企业版功能', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                SizedBox(height: 8),
                Text(
                  '• 团队成员互相监督\n'
                  '• 鸽子排行榜\n'
                  '• 管理者通知提醒\n'
                  '• 团队目标追踪',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamView() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 邀请码卡片
                _buildInviteCard(),
                const SizedBox(height: 24),
                // 鸽子排行榜
                _buildLeaderboard(),
                const SizedBox(height: 24),
                // 成员列表
                _buildMemberList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _team!.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                Text(
                  '${_team!.memberCount} 位成员',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.group, color: Colors.black, size: 32),
        ],
      ),
    );
  }

  Widget _buildInviteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFCCFF00),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.link, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('邀请码', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  _team!.inviteCode ?? '------',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 4),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _team!.inviteCode ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('邀请码已复制', style: TextStyle(fontWeight: FontWeight.w900)),
                  backgroundColor: Colors.black,
                ),
              );
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    final leaderboard = _team!.failLeaderboard.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🕊️ 鸽子排行榜',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        if (leaderboard.isEmpty)
          const Text('暂无数据', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
        else
          ...leaderboard.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: index == 0 ? const Color(0xFFFF3333) : Colors.grey[100],
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Row(
                children: [
                  Text(
                    '#${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: index == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      member.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: index == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    '${member.totalFails} 次',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: index == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildMemberList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '👥 成员',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Text(
              '${_team!.memberCount} 人',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._team!.members.map((member) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Center(
                  child: Text(
                    member.displayName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      member.role.name.toUpperCase(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(member.completionRate * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const Text(
                    '完成率',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }
}
