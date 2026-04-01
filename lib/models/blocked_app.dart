import 'app_tier.dart';

/// Represents an app that has been added to the block list.
class BlockedApp {
  final String name;
  final String? logoUrl;
  AppTier tier;
  final DateTime addedAt;

  /// Mock usage minutes for today (in a real app, sourced from Screen Time API).
  final int usedMinutes;

  BlockedApp({
    required this.name,
    this.logoUrl,
    this.tier = AppTier.normal,
    DateTime? addedAt,
    this.usedMinutes = 0,
  }) : addedAt = addedAt ?? DateTime.now();

  /// True while the 24-hour lock window is active (can't remove or re-add).
  bool get is24hrLocked =>
      DateTime.now().difference(addedAt) < const Duration(hours: 24);

  /// How much time is left in the 24-hour lock window.
  Duration get lockRemaining {
    final elapsed = DateTime.now().difference(addedAt);
    final remaining = const Duration(hours: 24) - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// True when today's allowance has been fully consumed.
  bool get timesUp => usedMinutes >= tier.allowanceMinutes;

  /// Minutes left in today's allowance.
  int get minutesRemaining =>
      (tier.allowanceMinutes - usedMinutes).clamp(0, tier.allowanceMinutes);

  BlockedApp copyWith({AppTier? tier, int? usedMinutes}) => BlockedApp(
        name: name,
        logoUrl: logoUrl,
        tier: tier ?? this.tier,
        addedAt: addedAt,
        usedMinutes: usedMinutes ?? this.usedMinutes,
      );
}
