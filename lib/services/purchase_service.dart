import 'package:purchases_flutter/purchases_flutter.dart';

/// 订阅类型
enum SubscriptionType {
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
  // 从环境变量读取 API Key，提供默认值用于开发环境
  static const String _apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'app5904c87b38',
  );
  static const String _entitlementId = 'toxic_tracker Pro';

  // Package identifiers (RevenueCat 后台配置)
  static const String _yearlyPackage = 'toxic_yearly_19.9';
  static const String _lifetimePackage = 'toxic_lifetime_68';

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

      // 年度订阅
      final yearly = current.getPackage(_yearlyPackage);
      if (yearly != null) {
        options.add(SubscriptionOption(
          type: SubscriptionType.yearly,
          title: '年度订阅',
          price: yearly.storeProduct.priceString,
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
        type: SubscriptionType.yearly,
        title: '年度订阅',
        price: '¥19.9/年',
        packageIdentifier: _yearlyPackage,
      ),
      SubscriptionOption(
        type: SubscriptionType.lifetime,
        title: '终身会员',
        price: '¥68',
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
        case SubscriptionType.yearly:
          package = current.getPackage(_yearlyPackage);
          break;
        case SubscriptionType.lifetime:
          package = current.getPackage(_lifetimePackage);
          break;
      }

      if (package == null) return false;

      // 使用新的 PurchaseParams API
      final purchaseParams = PurchaseParams.package(package);
      final result = await Purchases.purchase(purchaseParams);
      return result.customerInfo.entitlements.all[_entitlementId]?.isActive ?? false;
    } catch (e) {
      print('购买失败: $e');
      return false;
    }
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
