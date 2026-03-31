import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/app_tier.dart';
import '../../theme/tier_badge.dart';
import '../apps/app_logo.dart';
import '../tasks/task_screen.dart';

/// Full-screen lock modal shown when the user opens a blocked app.
class LockScreen extends StatelessWidget {
  final String appName;
  final String? appLogoUrl;
  final AppTier tier;

  const LockScreen({
    super.key,
    required this.appName,
    this.appLogoUrl,
    this.tier = AppTier.normal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.background : AppColors.lightBackground,
      body: Stack(
        children: [
          // Background
          Positioned.fill(child: DecoratedBox(decoration: AppBg.of(context))),
          // Heavy blur for the "inescapable" feeling
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const ColoredBox(color: Color(0x22000000)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _TopBar(),
                const Spacer(),
                _Identity(
                    appName: appName,
                    logoUrl: appLogoUrl,
                    tier: tier,
                    isDark: isDark),
                const Spacer(),
                _UnlockPanel(
                    appName: appName, tier: tier, isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x4, Sp.x5, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Rr.full),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sp.x3, vertical: Sp.x2),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDim
                        : AppColors.lightSurfaceDim,
                    borderRadius: BorderRadius.circular(Rr.full),
                    border: Border.all(
                        color: isDark
                            ? AppColors.glassStroke
                            : AppColors.lightGlassStroke,
                        width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          size: 12, color: mutedColor),
                      const SizedBox(width: Sp.x1),
                      Text('Go back',
                          style: TextStyle(
                              color: mutedColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.shield_rounded, size: 13, color: mutedColor),
              const SizedBox(width: Sp.x1),
              Text('AppGate',
                  style: TextStyle(
                      color: mutedColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── App identity ──────────────────────────────────────────────────────────────

class _Identity extends StatelessWidget {
  final String appName;
  final String? logoUrl;
  final AppTier tier;
  final bool isDark;

  const _Identity({
    required this.appName,
    required this.logoUrl,
    required this.tier,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.x8),
      child: Column(
        children: [
          // App logo
          ClipRRect(
            borderRadius: BorderRadius.circular(Rr.xxl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDim
                      : AppColors.lightSurfaceDim,
                  borderRadius: BorderRadius.circular(Rr.xxl),
                  border: Border.all(
                      color: isDark
                          ? AppColors.glassStroke
                          : AppColors.lightGlassStroke,
                      width: 0.5),
                ),
                child: Center(
                  child: AppLogo(
                    url: logoUrl,
                    name: appName,
                    size: 60,
                    borderRadius: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Sp.x5),
          Text(
            appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: Sp.x3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sp.x3, vertical: Sp.x1 + 2),
                decoration: BoxDecoration(
                  color: AppColors.blocked.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(Rr.full),
                  border: Border.all(
                      color: AppColors.blocked.withValues(alpha: 0.30),
                      width: 0.5),
                ),
                child: const Text('Blocked',
                    style: TextStyle(
                        color: AppColors.blocked,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: Sp.x2),
              TierBadge(tier: tier),
            ],
          ),
          const SizedBox(height: Sp.x5),
          Text(
            'Complete a task to earn a free unlock,\nor pay to access for the rest of today.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: subColor, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ── Unlock panel ──────────────────────────────────────────────────────────────

class _UnlockPanel extends StatelessWidget {
  final String appName;
  final AppTier tier;
  final bool isDark;

  const _UnlockPanel({
    required this.appName,
    required this.tier,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0x0DFFFFFF)
                : const Color(0x99FFFFFF),
            border: Border(
              top: BorderSide(
                  color: isDark
                      ? AppColors.glassStroke
                      : AppColors.lightGlassStroke,
                  width: 0.5),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, Sp.x8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Complete a task
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskScreen()),
                ),
                icon: const Icon(Icons.task_alt_rounded, size: 18),
                label: const Text('Complete a Task'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              const SizedBox(height: Sp.x3),
              // Pay to unlock
              OutlinedButton.icon(
                onPressed: () => _showPaySheet(context),
                icon: const Icon(Icons.bolt_rounded, size: 18),
                label: Text('Unlock for today — ${tier.unlockPrice}'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  foregroundColor: AppColors.warning,
                  side: BorderSide(
                      color: AppColors.warning.withValues(alpha: 0.45)),
                ),
              ),
              const SizedBox(height: Sp.x5),
              // Go back
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Text('Take me back',
                      style: TextStyle(
                          color: mutedColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaySheet(tier: tier, isDark: isDark),
    );
  }
}

// ── Pay sheet ─────────────────────────────────────────────────────────────────

class _PaySheet extends StatelessWidget {
  final AppTier tier;
  final bool isDark;

  const _PaySheet({required this.tier, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color:
                isDark ? const Color(0x1AFFFFFF) : const Color(0xCCFFFFFF),
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
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(Rr.md),
                    ),
                    child: const Icon(Icons.bolt_rounded,
                        color: AppColors.warning, size: 24),
                  ),
                  const SizedBox(width: Sp.x4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unlock for today',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      Text('${tier.unlockPrice} · resets at midnight',
                          style: TextStyle(
                              color: mutedColor, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Sp.x5),
              Divider(
                  height: 0.5,
                  color: isDark
                      ? AppColors.glassStroke
                      : AppColors.lightGlassStroke),
              const SizedBox(height: Sp.x4),
              Text(
                'You\'ll have unrestricted access to this app until midnight. This is a one-time charge per day.',
                style: TextStyle(
                    color: subColor, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: Sp.x6),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white),
                child: Text('Pay ${tier.unlockPrice} and Unlock',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              const SizedBox(height: Sp.x3),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text('Cancel',
                      style:
                          TextStyle(color: mutedColor, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
