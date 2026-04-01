import 'package:flutter/foundation.dart';
import '../models/app_tier.dart';
import '../models/blocked_app.dart';

/// Shared state for the blocked apps list.
/// Both AppsScreen and ChallengesScreen listen to this notifier.
class BlockedAppsNotifier {
  BlockedAppsNotifier._();

  static final notifier = ValueNotifier<List<BlockedApp>>([
    BlockedApp(
      name: 'Instagram',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/132px-Instagram_logo_2016.svg.png',
      tier: AppTier.normal,
      addedAt: DateTime.now().subtract(const Duration(days: 3)),
      usedMinutes: 30, // exactly at allowance → Time's up
    ),
    BlockedApp(
      name: 'TikTok',
      logoUrl:
          'https://sf16-website-login.neutral.ttwstatic.com/obj/tiktok_web_login_static/tiktok/webapp/main/webapp-desktop/8152caf0c8e8bc67ae0d.png',
      tier: AppTier.short,
      addedAt: DateTime.now().subtract(const Duration(days: 5)),
      usedMinutes: 12, // 3 min remaining (15min allowance)
    ),
    BlockedApp(
      name: 'Reddit',
      logoUrl: 'https://www.redditinc.com/assets/images/site/reddit-logo.png',
      tier: AppTier.normal,
      addedAt: DateTime.now().subtract(const Duration(days: 2)),
      usedMinutes: 18, // 12 min remaining (30min allowance)
    ),
  ]);

  static List<BlockedApp> get apps => notifier.value;

  static void add(BlockedApp app) {
    notifier.value = [...notifier.value, app];
  }

  static void remove(int index) {
    final list = [...notifier.value];
    list.removeAt(index);
    notifier.value = list;
  }

  static void updateTier(int index, AppTier tier) {
    final list = [...notifier.value];
    list[index] = list[index].copyWith(tier: tier);
    notifier.value = list;
  }
}
