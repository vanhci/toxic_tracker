import 'package:flutter/material.dart';
import '../services/purchase_service.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isPurchasing = false;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final isPremium = await PurchaseService.isPremiumUser();
    if (mounted) {
      setState(() => _isPremium = isPremium);
    }
  }

  Future<void> _purchaseYearly() async {
    if (_isPurchasing) return;
    setState(() => _isPurchasing = true);

    try {
      final success = await PurchaseService.purchase(SubscriptionType.yearly);
      if (!mounted) return;

      if (success) {
        setState(() => _isPremium = true);
        _showSuccessDialog('算你识相，行刑室已升级。');
      } else {
        _showFailDialog('穷鬼，点错了是吧？');
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _purchaseLifetime() async {
    if (_isPurchasing) return;
    setState(() => _isPurchasing = true);

    try {
      final success = await PurchaseService.purchase(SubscriptionType.lifetime);
      if (!mounted) return;

      if (success) {
        setState(() => _isPremium = true);
        _showSuccessDialog('卧槽，真买了？行刑室已永久升级。');
      } else {
        _showFailDialog('穷鬼，点错了是吧？');
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  void _showSuccessDialog(String message) {
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
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(4, 4), blurRadius: 0)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCFF00),
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 3)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text('继续',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFailDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(4, 4), blurRadius: 0)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🫵', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 3)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text('继续被 Amanda 骂',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
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
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
      ),
      child: const Column(
        children: [
          Text('💸', style: TextStyle(fontSize: 56)),
          SizedBox(height: 16),
          Text(
            '怎么，连杯奶茶钱都不舍得？\n还谈什么自律？',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w900, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildCoachCard(
          emoji: '👩‍💼',
          name: 'Amanda',
          status: '已被你白嫖',
          isFree: true,
        ),
        const SizedBox(height: 16),
        _buildCoachCard(
          emoji: '🥁',
          name: '退堂鼓区长',
          status: '专业打击你的自信心',
          isFree: false,
        ),
        const SizedBox(height: 16),
        _buildCoachCard(
          emoji: '📋',
          name: '扫兴的王主任',
          status: '让你想起被KPI支配的恐惧',
          isFree: false,
        ),
      ],
    );
  }

  Widget _buildCoachCard({
    required String emoji,
    required String name,
    required String status,
    required bool isFree,
  }) {
    final isUnlocked = isFree || _isPremium;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.grey[100],
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900)),
                    if (!isUnlocked) ...[
                      const SizedBox(width: 8),
                      const Text('🔒', style: TextStyle(fontSize: 18)),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: isFree ? const Color(0xFFCCFF00) : Colors.black,
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isFree ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            const Icon(Icons.check, color: Colors.black, size: 28)
          else
            const Icon(Icons.lock_outline, color: Colors.black, size: 28),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isPremium) ...[
            // 年度订阅按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPurchasing ? null : _purchaseYearly,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFF00),
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 3)),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                ).copyWith(
                  shadowColor: WidgetStateProperty.all(Colors.black),
                  surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: _isPurchasing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.black),
                      )
                    : const Text('¥19.9 施舍你一年',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 12),
            // 终身买断按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPurchasing ? null : _purchaseLifetime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[600],
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 3)),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                ),
                child: const Text('¥68 永远买断这破App',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // 穷鬼退路
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              _isPremium ? '已解锁全部教练，继续' : '算了，我继续被 Amanda 骂',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
