import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY'; // TODO: 替换为你的 RevenueCat API Key
  static const String _monthlyEntitlement = 'pro'; // RevenueCat 后台配置的权益标识

  static Future<void> initialize() async {
    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  static Future<bool> isPremiumUser() async {
    final customerInfo = await Purchases.getCustomerInfo();
    return customerInfo.entitlements.all[_monthlyEntitlement]?.isActive ?? false;
  }

  static Future<bool> purchaseMonthly() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return false;

      final monthly = current.monthly;
      if (monthly == null) return false;

      final customerInfo = await Purchases.purchasePackage(monthly);
      return customerInfo.entitlements.all[_monthlyEntitlement]?.isActive ?? false;
    } catch (e) {
      print('购买失败: $e');
      return false;
    }
  }

  static Future<void> restorePurchases() async {
    await Purchases.restorePurchases();
  }
}
