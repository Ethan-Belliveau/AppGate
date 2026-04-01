import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/app_tier.dart';
import '../../models/blocked_app.dart';
import '../../state/blocked_apps_notifier.dart';
import '../../theme/tier_badge.dart';
import '../apps/app_logo.dart';
import '../tasks/task_screen.dart';

// ── Unlock option definition ──────────────────────────────────────────────────

class _UnlockOption {
  final String label;
  final String taskDuration;
  final String accessDuration;
  final String price;

  const _UnlockOption({
    required this.label,
    required this.taskDuration,
    required this.accessDuration,
    required this.price,
  });
}

const _quick =
    _UnlockOption(label: 'Quick', taskDuration: '~5 min', accessDuration: '20 min', price: r'$0.25');
const _standard =
    _UnlockOption(label: 'Standard', taskDuration: '~15 min', accessDuration: '1 hr', price: r'$0.50');
const _deep =
    _UnlockOption(label: 'Deep', taskDuration: '~30 min', accessDuration: '3 hrs', price: r'$0.99');

List<_UnlockOption> _optionsForTier(AppTier tier) => switch (tier) {
      AppTier.short => [_quick],
      AppTier.normal => [_quick, _standard],
      AppTier.long => [_quick, _standard, _deep],
    };

// ── Screen ────────────────────────────────────────────────────────────────────

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ValueListenableBuilder<List<BlockedApp>>(
          valueListenable: BlockedAppsNotifier.notifier,
          builder: (_, apps, __) {
            if (apps.isEmpty) {
              return _EmptyNoApps();
            }

            final timesUpApps =
                apps.where((a) => a.timesUp).toList();

            return CustomScrollView(
              slivers: [
                // Header
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Challenges',
                            style:
                                Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 2),
                        Text(
                          timesUpApps.isEmpty
                              ? 'All within limits today'
                              : '${timesUpApps.length} app${timesUpApps.length != 1 ? 's' : ''} need unlocking',
                          style:
                              TextStyle(color: subColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),

                // Cards
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                      Sp.x5, Sp.x5, Sp.x5, Sp.x12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: Sp.x3),
                        child: _AppChallengeCard(
                          app: apps[i],
                          onUnlock: () =>
                              _showUnlockSheet(context, apps[i], isDark),
                        ),
                      ),
                      childCount: apps.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showUnlockSheet(
      BuildContext context, BlockedApp app, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _UnlockSheet(app: app, isDark: isDark),
    );
  }
}

// ── App challenge card ────────────────────────────────────────────────────────

class _AppChallengeCard extends StatelessWidget {
  final BlockedApp app;
  final VoidCallback onUnlock;

  const _AppChallengeCard({required this.app, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.surfaceDim : AppColors.lightSurfaceDim,
            borderRadius: BorderRadius.circular(Rr.xl),
            border: Border.all(
              color: app.timesUp
                  ? AppColors.blocked.withValues(alpha: 0.35)
                  : (isDark
                      ? AppColors.glassStroke
                      : AppColors.lightGlassStroke),
              width: app.timesUp ? 1.0 : 0.5,
            ),
            boxShadow: app.timesUp
                ? [
                    BoxShadow(
                      color: AppColors.blocked.withValues(alpha: 0.10),
                      blurRadius: 16,
                      spreadRadius: 0,
                    )
                  ]
                : (isDark
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0x0F000000),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        )
                      ]),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: app.timesUp ? onUnlock : null,
              borderRadius: BorderRadius.circular(Rr.xl),
              child: Padding(
                padding: const EdgeInsets.all(Sp.x4),
                child: Row(
                  children: [
                    // App logo
                    AppLogo(
                        url: app.logoUrl,
                        name: app.name,
                        size: 52,
                        borderRadius: 12),
                    const SizedBox(width: Sp.x4),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(app.name,
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                              TierBadge(tier: app.tier, compact: true),
                            ],
                          ),
                          const SizedBox(height: 5),
                          _StatusBadge(app: app),
                        ],
                      ),
                    ),
                    // Chevron (only when tappable)
                    if (app.timesUp) ...[
                      const SizedBox(width: Sp.x2),
                      Icon(Icons.chevron_right_rounded,
                          color: AppColors.blocked, size: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BlockedApp app;
  const _StatusBadge({required this.app});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (app.timesUp) {
      return Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.blocked,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            "Time's up — tap to unlock",
            style: TextStyle(
              color: AppColors.blocked,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    final remaining = app.minutesRemaining;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    return Text(
      '$remaining min remaining',
      style: TextStyle(
        color: mutedColor,
        fontSize: 12,
      ),
    );
  }
}

// ── Unlock sheet ──────────────────────────────────────────────────────────────

class _UnlockSheet extends StatelessWidget {
  final BlockedApp app;
  final bool isDark;

  const _UnlockSheet({required this.app, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final options = _optionsForTier(app.tier);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0x1AFFFFFF)
                  : const Color(0xCCFFFFFF),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
              border: Border(
                  top: BorderSide(
                      color: isDark
                          ? AppColors.glassStroke
                          : AppColors.lightGlassStroke,
                      width: 0.5)),
            ),
            padding:
                const EdgeInsets.fromLTRB(Sp.x6, Sp.x5, Sp.x6, Sp.x10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.glassStroke
                          : AppColors.lightGlassStroke,
                      borderRadius: BorderRadius.circular(Rr.full),
                    ),
                  ),
                ),
                const SizedBox(height: Sp.x5),
                // App header
                Row(
                  children: [
                    AppLogo(
                        url: app.logoUrl,
                        name: app.name,
                        size: 44,
                        borderRadius: 10),
                    const SizedBox(width: Sp.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(app.name,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          Text('Choose how to unlock',
                              style: TextStyle(
                                  color: subColor, fontSize: 13)),
                        ],
                      ),
                    ),
                    TierBadge(tier: app.tier),
                  ],
                ),
                const SizedBox(height: Sp.x5),
                Divider(
                    height: 0.5,
                    color: isDark
                        ? AppColors.glassStroke
                        : AppColors.lightGlassStroke),
                const SizedBox(height: Sp.x4),
                // Unlock option rows
                ...options.map((opt) => Padding(
                      padding: const EdgeInsets.only(bottom: Sp.x3),
                      child: _UnlockOptionRow(
                        option: opt,
                        isDark: isDark,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        onStartTask: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TaskScreen(),
                            ),
                          );
                        },
                        onPay: () => Navigator.pop(context),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnlockOptionRow extends StatelessWidget {
  final _UnlockOption option;
  final bool isDark;
  final Color textColor;
  final Color mutedColor;
  final VoidCallback onStartTask;
  final VoidCallback onPay;

  const _UnlockOptionRow({
    required this.option,
    required this.isDark,
    required this.textColor,
    required this.mutedColor,
    required this.onStartTask,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sp.x4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0x0AFFFFFF)
            : const Color(0x0A000000),
        borderRadius: BorderRadius.circular(Rr.lg),
        border: Border.all(
            color: isDark
                ? AppColors.glassStroke
                : AppColors.lightGlassStroke,
            width: 0.5),
      ),
      child: Row(
        children: [
          // Option info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option.label,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  '${option.taskDuration} task · ${option.accessDuration} access',
                  style: TextStyle(color: mutedColor, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: Sp.x3),
          // Pay button
          GestureDetector(
            onTap: onPay,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Sp.x3, vertical: Sp.x2),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rr.md),
                border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.35),
                    width: 0.5),
              ),
              child: Text(
                option.price,
                style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: Sp.x2),
          // Start Task button
          GestureDetector(
            onTap: onStartTask,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Sp.x3, vertical: Sp.x2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rr.md),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 0.5),
              ),
              child: const Text(
                'Start Task',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty states ──────────────────────────────────────────────────────────────

class _EmptyNoApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sp.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.surfaceDim : AppColors.lightSurfaceDim,
                shape: BoxShape.circle,
                border: Border.all(
                    color: isDark
                        ? AppColors.glassStroke
                        : AppColors.lightGlassStroke,
                    width: 0.5),
              ),
              child: Icon(Icons.task_alt_rounded,
                  color: mutedColor, size: 32),
            ),
            const SizedBox(height: Sp.x5),
            Text('No challenges yet',
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: Sp.x2),
            Text(
              'Head to Apps to start blocking.',
              textAlign: TextAlign.center,
              style: TextStyle(color: subColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
