import 'app_tier.dart';

/// Represents a device app managed by AppGate.
class AppEntry {
  final String id;
  final String name;
  final String bundleId;
  bool isBlocked;
  AppTier tier;
  int? timeLimitMinutes;
  int usedMinutesToday;

  AppEntry({
    required this.id,
    required this.name,
    required this.bundleId,
    this.isBlocked = false,
    this.tier = AppTier.normal,
    this.timeLimitMinutes,
    this.usedMinutesToday = 0,
  });

  int get remainingMinutes {
    final limit = timeLimitMinutes ?? tier.allowanceMinutes;
    return (limit - usedMinutesToday).clamp(0, limit);
  }

  AppEntry copyWith({
    bool? isBlocked,
    AppTier? tier,
    int? timeLimitMinutes,
    int? usedMinutesToday,
  }) {
    return AppEntry(
      id: id,
      name: name,
      bundleId: bundleId,
      isBlocked: isBlocked ?? this.isBlocked,
      tier: tier ?? this.tier,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      usedMinutesToday: usedMinutesToday ?? this.usedMinutesToday,
    );
  }
}
