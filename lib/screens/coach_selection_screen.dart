import 'package:flutter/material.dart';
import '../models/coach.dart';
import '../services/purchase_service.dart';

class CoachSelectionScreen extends StatefulWidget {
  const CoachSelectionScreen({super.key});

  @override
  State<CoachSelectionScreen> createState() => _CoachSelectionScreenState();
}

class _CoachSelectionScreenState extends State<CoachSelectionScreen> {
  List<Coach> _coaches = Coach.defaultCoaches;
  bool _isPurchasing = false;

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

  void _showPaywallDialog(Coach coach) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔒', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 16),
              const Text(
                '连杯奶茶钱都不舍得\n还谈什么自律？',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              Text(
                '解锁「${coach.name}」及全部教练',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isPurchasing
                      ? null
                      : () async {
                          setState(() => _isPurchasing = true);
                          final success = await PurchaseService.purchaseMonthly();
                          if (success && mounted) {
                            setState(() {
                              _coaches = Coach.defaultCoaches.map((c) => c.copyWith(isUnlocked: true)).toList();
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('🎉 解锁成功！现在你可以选择任意教练了。', style: TextStyle(fontWeight: FontWeight.w900)),
                                backgroundColor: Color(0xFFCCFF00),
                              ),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('购买失败或取消，请稍后再试。', style: TextStyle(fontWeight: FontWeight.w900)),
                                backgroundColor: Color(0xFFFF3333),
                              ),
                            );
                          }
                          setState(() => _isPurchasing = false);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: _isPurchasing
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                      : const Text('立即解锁 9.9元/月', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text('算了，我继续被 Amanda 骂', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
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
