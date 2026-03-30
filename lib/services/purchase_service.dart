/// Handles in-app purchases for one-time app unlocks.
/// Integrate with `in_app_purchase` package when ready.
class PurchaseService {
  static const String unlockProductId = 'com.ethanbelliveau.appgate.unlock_once';

  bool _isPurchasing = false;

  bool get isPurchasing => _isPurchasing;

  /// Initiates a one-time unlock purchase for [appId].
  /// Returns true if the purchase was successful.
  Future<bool> purchaseUnlock({required String appId}) async {
    _isPurchasing = true;
    try {
      // TODO: integrate StoreKit (iOS) / Google Play Billing via in_app_purchase
      await Future.delayed(const Duration(seconds: 1)); // placeholder
      return true;
    } finally {
      _isPurchasing = false;
    }
  }

  Future<bool> restorePurchases() async {
    // TODO: restore previous unlocks
    return false;
  }
}
