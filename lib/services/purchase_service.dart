import 'package:purchases_flutter/purchases_flutter.dart';

/// 订阅类型
enum SubscriptionType {
  monthly,
  yearly,
  lifetime,
}

/// 订阅选项
class SubscriptionOption {
  final SubscriptionType type;
  final String title;
  final String price;
  final String? originalPrice;
  final String? savings;
  final String packageIdentifier;

  const SubscriptionOption({
    required this.type,
    required this.title,
    required this.price,
    this.originalPrice,
    this.savings,
    required this.packageIdentifier,
  });
}

class PurchaseService {
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY'; // TODO: 替换为你的 RevenueCat API Key
  static const String _entitlementId = 'pro'; // RevenueCat 后台配置的权益标识

  // Package identifiers (需要在 RevenueCat 后台配置)
  static const String _monthlyPackage = 'monthly';
  static const String _yearlyPackage = 'yearly';
  static const String _lifetimePackage = 'lifetime';

  static Future<void> initialize() async {
    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  static Future<bool> isPremiumUser() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[_entitlementId]?.isActive ?? false;
    } catch (e) {
      print('检查会员状态失败: $e');
      return false;
    }
  }

  /// 获取可用的订阅选项
  static Future<List<SubscriptionOption>> getSubscriptionOptions() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return _getDefaultOptions();

      final options = <SubscriptionOption>[];

      // 月度订阅
      final monthly = current.getPackage(_monthlyPackage);
      if (monthly != null) {
        options.add(SubscriptionOption(
          type: SubscriptionType.monthly,
          title: '月度订阅',
          price: monthly.storeProduct.priceString,
          packageIdentifier: monthly.identifier,
        ));
      }

      // 年度订阅
      final yearly = current.getPackage(_yearlyPackage);
      if (yearly != null) {
        final monthlyPrice = monthly?.storeProduct.price ?? 0;
        final yearlyPrice = yearly.storeProduct.price;
        final yearlyMonthly = yearlyPrice / 12;
        final savings = ((1 - yearlyMonthly / monthlyPrice) * 100).round();

        options.add(SubscriptionOption(
          type: SubscriptionType.yearly,
          title: '年度订阅',
          price: yearly.storeProduct.priceString,
          originalPrice: '¥118.8/年',
          savings: '省 $savings%',
          packageIdentifier: yearly.identifier,
        ));
      }

      // 终身买断
      final lifetime = current.getPackage(_lifetimePackage);
      if (lifetime != null) {
        options.add(SubscriptionOption(
          type: SubscriptionType.lifetime,
          title: '终身会员',
          price: lifetime.storeProduct.priceString,
          packageIdentifier: lifetime.identifier,
        ));
      }

      return options.isEmpty ? _getDefaultOptions() : options;
    } catch (e) {
      print('获取订阅选项失败: $e');
      return _getDefaultOptions();
    }
  }

  static List<SubscriptionOption> _getDefaultOptions() {
    return const [
      SubscriptionOption(
        type: SubscriptionType.monthly,
        title: '月度订阅',
        price: '¥9.9/月',
        packageIdentifier: _monthlyPackage,
      ),
      SubscriptionOption(
        type: SubscriptionType.yearly,
        title: '年度订阅',
        price: '¥68/年',
        originalPrice: '¥118.8/年',
        savings: '省 42%',
        packageIdentifier: _yearlyPackage,
      ),
      SubscriptionOption(
        type: SubscriptionType.lifetime,
        title: '终身会员',
        price: '¥98',
        packageIdentifier: _lifetimePackage,
      ),
    ];
  }

  /// 购买订阅
  static Future<bool> purchase(SubscriptionType type) async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return false;

      Package? package;
      switch (type) {
        case SubscriptionType.monthly:
          package = current.getPackage(_monthlyPackage);
          break;
        case SubscriptionType.yearly:
          package = current.getPackage(_yearlyPackage);
          break;
        case SubscriptionType.lifetime:
          package = current.getPackage(_lifetimePackage);
          break;
      }

      if (package == null) return false;

      final customerInfo = await Purchases.purchasePackage(package);
      return customerInfo.entitlements.all[_entitlementId]?.isActive ?? false;
    } catch (e) {
      print('购买失败: $e');
      return false;
    }
  }

  /// 购买月度订阅（兼容旧 API）
  static Future<bool> purchaseMonthly() async {
    return await purchase(SubscriptionType.monthly);
  }

  /// 恢复购买
  static Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all[_entitlementId]?.isActive ?? false;
    } catch (e) {
      print('恢复购买失败: $e');
      return false;
    }
  }
}
