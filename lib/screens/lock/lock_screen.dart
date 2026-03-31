import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/app_tier.dart';
import '../../theme/tier_badge.dart';
import '../tasks/task_screen.dart';

/// Full-screen lock modal shown when a blocked app is opened.
/// The 40-sigma blur gives an "inescapable" frosted feel.
class LockScreen extends StatelessWidget {
  final String appName;
  final AppTier tier;
  final int remainingMinutes;
  final bool isPro;
  final Color? appColor;

  const LockScreen({
    super.key,
    required this.appName,
    this.tier = AppTier.normal,
    this.remainingMinutes = 0,
    this.isPro = false,
    this.appColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Heavy blur backdrop
          const Positioned.fill(
            child: DecoratedBox(decoration: AppBg.decoration),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const ColoredBox(color: Color(0x33000000)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _TopBar(),
                const Spacer(),
                _AppIdentity(
                  appName: appName,
                  tier: tier,
                  remainingMinutes: remainingMinutes,
                  appColor: appColor ??
                      _defaultColor(appName),
                ),
                const Spacer(),
                _UnlockPanel(
                  appName: appName,
                  tier: tier,
                  remainingMinutes: remainingMinutes,
                  isPro: isPro,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _defaultColor(String name) {
    final colors = [
      AppColors.primary,
      AppColors.tierShort,
      AppColors.tierNormal,
      AppColors.tierLong,
      AppColors.info,
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.surfaceDim,
                    borderRadius: BorderRadius.circular(Rr.full),
                    border: Border.all(
                        color: AppColors.glassStroke, width: 0.5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          size: 12, color: AppColors.textSecondary),
                      SizedBox(width: Sp.x1),
                      Text(
                        'Go back',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          const Row(
            children: [
              Icon(Icons.shield_rounded, size: 13, color: AppColors.textMuted),
              SizedBox(width: Sp.x1),
              Text(
                'AppGate',
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── App identity ──────────────────────────────────────────────────────────────

class _AppIdentity extends StatelessWidget {
  final String appName;
  final AppTier tier;
  final int remainingMinutes;
  final Color appColor;

  const _AppIdentity({
    required this.appName,
    required this.tier,
    required this.remainingMinutes,
    required this.appColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.x8),
      child: Column(
        children: [
          // App icon — large, tier-colored
          ClipRRect(
            borderRadius: BorderRadius.circular(Rr.xxl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: appColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Rr.xxl),
                  border: Border.all(
                      color: appColor.withValues(alpha: 0.35)),
                ),
                child: Center(
                  child: Text(
                    appName.isNotEmpty ? appName[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: appColor,
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
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
          // Blocked badge
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulseDot(color: AppColors.blocked),
                SizedBox(width: Sp.x2),
                Text(
                  'Blocked by AppGate',
                  style: TextStyle(
                      color: AppColors.blocked,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sp.x3),
          // Tier + allowance
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TierBadge(tier: tier),
              const SizedBox(width: Sp.x2),
              Text(
                remainingMinutes > 0
                    ? '$remainingMinutes min remaining today'
                    : 'No allowance remaining',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: Sp.x5),
          const Text(
            'You set this app as off-limits.\nComplete a task or use your allowance to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  final Color color;

  const _PulseDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ── Unlock panel ──────────────────────────────────────────────────────────────

class _UnlockPanel extends StatelessWidget {
  final String appName;
  final AppTier tier;
  final int remainingMinutes;
  final bool isPro;

  const _UnlockPanel({
    required this.appName,
    required this.tier,
    required this.remainingMinutes,
    required this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x0DFFFFFF),
            border: Border(
              top: BorderSide(color: AppColors.glassStroke, width: 0.5),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
              Sp.x5, Sp.x5, Sp.x5, Sp.x8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option 1: Use allowance (if remaining)
              if (remainingMinutes > 0) ...[
                OutlinedButton.icon(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.timer_outlined, size: 18),
                  label: Text('Use ${remainingMinutes}m of allowance'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: BorderSide(
                        color: AppColors.glassStrokeMed),
                  ),
                ),
                const SizedBox(height: Sp.x3),
              ],
              // Option 2: Complete a task
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
              // Option 3: Pay to unlock (Pro) or upgrade prompt
              if (isPro)
                OutlinedButton.icon(
                  onPressed: () => _showPaySheet(context),
                  icon: const Icon(Icons.bolt_rounded, size: 18),
                  label: Text('Unlock Now — ${tier.unlockPrice}'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    foregroundColor: AppColors.warning,
                    side: BorderSide(
                        color: AppColors.warning.withValues(alpha: 0.4)),
                  ),
                )
              else
                GestureDetector(
                  onTap: () => _showUpgradeSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Sp.x3 + 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Rr.md),
                      border: Border.all(
                          color: AppColors.glassStroke, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bolt_rounded,
                            size: 16, color: AppColors.textMuted),
                        const SizedBox(width: Sp.x2),
                        Text(
                          'Unlock Now ${tier.unlockPrice}  ·  Pro only',
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: Sp.x4),
              // Go back link
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Text(
                    'Take me back',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
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
      builder: (_) => _PaySheet(tier: tier),
    );
  }

  void _showUpgradeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _UpgradeSheet(),
    );
  }
}

// ── Pay to unlock sheet ───────────────────────────────────────────────────────

class _PaySheet extends StatelessWidget {
  final AppTier tier;

  const _PaySheet({required this.tier});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x1AFFFFFF),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
            border: Border(
                top: BorderSide(color: AppColors.glassStroke, width: 0.5)),
          ),
          padding: const EdgeInsets.fromLTRB(
              Sp.x6, Sp.x5, Sp.x6, Sp.x10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.glassStroke,
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
                      const Text(
                        'Pay to Unlock',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${tier.unlockPrice} · valid until midnight',
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Sp.x5),
              const Divider(height: 0.5, color: AppColors.glassStroke),
              const SizedBox(height: Sp.x5),
              const Text(
                'You\'ll have full access until midnight. Non-refundable and does not carry over.',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5),
              ),
              const SizedBox(height: Sp.x6),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(
                  'Pay ${tier.unlockPrice} and Unlock',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              const SizedBox(height: Sp.x3),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Upgrade sheet (Free users) ────────────────────────────────────────────────

class _UpgradeSheet extends StatelessWidget {
  const _UpgradeSheet();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x1AFFFFFF),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
            border: Border(
                top: BorderSide(color: AppColors.glassStroke, width: 0.5)),
          ),
          padding: const EdgeInsets.fromLTRB(
              Sp.x6, Sp.x5, Sp.x6, Sp.x10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.glassStroke,
                    borderRadius: BorderRadius.circular(Rr.full),
                  ),
                ),
              ),
              const SizedBox(height: Sp.x5),
              Container(
                padding: const EdgeInsets.all(Sp.x5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(Rr.xl),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.30),
                      width: 0.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: AppColors.primary, size: 32),
                    const SizedBox(height: Sp.x3),
                    const Text(
                      'Pro Unlocks More',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: Sp.x2),
                    const Text(
                      'Pay-to-unlock, custom tasks, detailed stats, and Strict Mode.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Sp.x5),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Upgrade to Pro — \$4.99/mo'),
              ),
              const SizedBox(height: Sp.x2),
              Center(
                child: Text(
                  '\$34.99/yr · Save 42%',
                  style: TextStyle(
                      color: AppColors.primary.withValues(alpha: 0.6),
                      fontSize: 12),
                ),
              ),
              const SizedBox(height: Sp.x4),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Not now',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
