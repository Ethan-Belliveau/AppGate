import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Three tier levels that control allowance, task difficulty, and unlock price.
enum AppTier { short, normal, long }

extension AppTierX on AppTier {
  String get label => switch (this) {
        AppTier.short => 'Short',
        AppTier.normal => 'Normal',
        AppTier.long => 'Long',
      };

  /// Daily screen-time allowance for this tier.
  int get allowanceMinutes => switch (this) {
        AppTier.short => 15,
        AppTier.normal => 30,
        AppTier.long => 60,
      };

  String get allowanceLabel => '${allowanceMinutes}m/day';

  /// Pro-only pay-to-unlock price string.
  String get unlockPrice => switch (this) {
        AppTier.short => '\$0.25',
        AppTier.normal => '\$0.50',
        AppTier.long => '\$0.99',
      };

  /// Task duration hint shown on task cards.
  String get taskDuration => switch (this) {
        AppTier.short => '~5 min',
        AppTier.normal => '~15 min',
        AppTier.long => '~30 min',
      };

  Color get color => switch (this) {
        AppTier.short => AppColors.tierShort,
        AppTier.normal => AppColors.tierNormal,
        AppTier.long => AppColors.tierLong,
      };
}
