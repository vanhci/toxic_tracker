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
  SubscriptionType _selectedPlan = SubscriptionType.yearly;

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
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
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
                  const Text('🔒', style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 12),
                  const Text(
                    '连杯奶茶钱都不舍得\n还谈什么自律？',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '解锁「${coach.name}」及全部教练',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // 订阅选项
                  _buildPlanOption(
                    context: dialogContext,
                    setDialogState: setDialogState,
                    type: SubscriptionType.monthly,
                    title: '月度订阅',
                    price: '¥9.9/月',
                    isRecommended: false,
                  ),
                  const SizedBox(height: 8),
                  _buildPlanOption(
                    context: dialogContext,
                    setDialogState: setDialogState,
                    type: SubscriptionType.yearly,
                    title: '年度订阅',
                    price: '¥68/年',
                    subtitle: '仅 ¥5.7/月，省 ¥50',
                    isRecommended: true,
                  ),
                  const SizedBox(height: 8),
                  _buildPlanOption(
                    context: dialogContext,
                    setDialogState: setDialogState,
                    type: SubscriptionType.lifetime,
                    title: '终身会员',
                    price: '¥98',
                    subtitle: '一次付费，永久使用',
                    isRecommended: false,
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPurchasing
                          ? null
                          : () async {
                              setDialogState(() => _isPurchasing = true);
                              final success = await PurchaseService.purchase(_selectedPlan);

                              if (success) {
                                // 先关闭 dialog
                                Navigator.of(dialogContext).pop();
                                // 更新 state
                                setState(() {
                                  _coaches = Coach.defaultCoaches.map((c) => c.copyWith(isUnlocked: true)).toList();
                                });
                                if (mounted) {
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    const SnackBar(
                                      content: Text('🎉 解锁成功！现在你可以选择任意教练了。', style: TextStyle(fontWeight: FontWeight.w900)),
                                      backgroundColor: Color(0xFFCCFF00),
                                    ),
                                  );
                                }
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    const SnackBar(
                                      content: Text('购买失败或取消，请稍后再试。', style: TextStyle(fontWeight: FontWeight.w900)),
                                      backgroundColor: Color(0xFFFF3333),
                                    ),
                                  );
                                }
                              }
                              if (mounted) {
                                setDialogState(() => _isPurchasing = false);
                              }
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
                          : const Text('立即解锁', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('算了，我继续被 Amanda 骂', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanOption({
    required BuildContext context,
    required StateSetter setDialogState,
    required SubscriptionType type,
    required String title,
    required String price,
    String? subtitle,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedPlan == type;

    return GestureDetector(
      onTap: () => setDialogState(() => _selectedPlan = type),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCCFF00) : Colors.grey[100],
          border: Border.all(
            color: isRecommended ? const Color(0xFFCCFF00) : Colors.black,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected ? const [BoxShadow(color: Colors.black, offset: Offset(2, 2))] : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          color: Colors.black,
                          child: const Text('推荐', style: TextStyle(color: Color(0xFFCCFF00), fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null)
                    Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ),
            Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ],
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
