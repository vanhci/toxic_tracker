import 'package:flutter/material.dart';
import '../models/coach.dart';
import '../services/purchase_service.dart';
import 'paywall_screen.dart';

class CoachSelectionScreen extends StatefulWidget {
  const CoachSelectionScreen({super.key});

  @override
  State<CoachSelectionScreen> createState() => _CoachSelectionScreenState();
}

class _CoachSelectionScreenState extends State<CoachSelectionScreen> {
  List<Coach> _coaches = Coach.defaultCoaches;

  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final isPremium = await PurchaseService.isPremiumUser();
    if (isPremium) {
      setState(() {
        _coaches = Coach.defaultCoaches.map((c) => c.copyWith(isUnlocked: true)).toList();
      });
    }
  }

  void _selectCoach(Coach coach) {
    if (coach.isPremium && !coach.isUnlocked) {
      _showPaywallDialog(coach);
      return;
    }

    Navigator.pop(context, coach);
  }

  void _showPaywallDialog(Coach coach) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const PaywallScreen()),
    );

    if (result == true && mounted) {
      setState(() {
        _coaches = Coach.defaultCoaches.map((c) => c.copyWith(isUnlocked: true)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildCoachList()),
          ],
        ),
      ),
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
          const Expanded(
            child: Text(
              '选择你的行刑官',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _coaches.length,
      itemBuilder: (context, index) {
        final coach = _coaches[index];
        return _buildCoachCard(coach);
      },
    );
  }

  Widget _buildCoachCard(Coach coach) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: coach.isUnlocked ? Colors.white : Colors.grey[100],
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: InkWell(
        onTap: () => _selectCoach(coach),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(coach.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          coach.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        if (coach.isPremium && !coach.isUnlocked) ...[
                          const SizedBox(width: 8),
                          const Text('🔒', style: TextStyle(fontSize: 18)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: Colors.black,
                      child: Text(
                        coach.style,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      coach.greeting,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
