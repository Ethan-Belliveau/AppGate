import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../tasks/task_screen.dart';

/// The most important screen in AppGate.
/// Shown when the user tries to open a blocked app.
/// Tone: firm but not hostile. Clear path forward.
class LockScreen extends StatelessWidget {
  final String appName;

  /// If the app had a time limit, pass usage context here.
  final String? usageContext; // e.g. "Used 30m of 30m today"

  const LockScreen({
    super.key,
    required this.appName,
    this.usageContext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            const Spacer(),
            _AppIdentity(appName: appName, usageContext: usageContext),
            const Spacer(),
            _UnlockPanel(appName: appName),
          ],
        ),
      ),
    );
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
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(
                  horizontal: Sp.x3, vertical: Sp.x2),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(Rr.full),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded,
                      size: 13, color: AppColors.textSecondary),
                  SizedBox(width: Sp.x1),
                  Text('Back',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.shield_rounded,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: Sp.x1),
              const Text('AppGate',
                  style: TextStyle(
                      color: AppColors.textMuted,
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

class _AppIdentity extends StatelessWidget {
  final String appName;
  final String? usageContext;

  const _AppIdentity({required this.appName, this.usageContext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.x8),
      child: Column(
        children: [
          // App icon placeholder — shows first letter of app name
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(Rr.xl),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Center(
              child: Text(
                appName.isNotEmpty ? appName[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: Sp.x5),
          Text(
            appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
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
              color: AppColors.blocked.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Rr.full),
              border: Border.all(
                  color: AppColors.blocked.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.blocked,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: Sp.x2),
                const Text(
                  'Blocked by AppGate',
                  style: TextStyle(
                    color: AppColors.blocked,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          if (usageContext != null) ...[
            const SizedBox(height: Sp.x3),
            Text(
              usageContext!,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 13),
            ),
          ],
          const SizedBox(height: Sp.x5),
          Text(
            'You set this app as off-limits.\nComplete a challenge or purchase a one-time unlock.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Unlock panel ──────────────────────────────────────────────────────────────

class _UnlockPanel extends StatelessWidget {
  final String appName;
  const _UnlockPanel({required this.appName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, Sp.x6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary: complete a challenge
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TaskScreen()),
            ),
            icon: const Icon(Icons.task_alt_rounded, size: 18),
            label: const Text('Complete a Challenge'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: Sp.x3),
          // Secondary: unlock once via IAP
          OutlinedButton.icon(
            onPressed: () => _showPurchaseSheet(context),
            icon: const Icon(Icons.bolt_rounded, size: 18),
            label: const Text('Unlock Once — \$0.99'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: Sp.x4),
          // Tertiary: just go back
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
    );
  }

  void _showPurchaseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Rr.xl)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(Sp.x6, Sp.x6, Sp.x6, Sp.x10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Rr.sm),
                  ),
                  child: const Icon(Icons.bolt_rounded,
                      color: AppColors.warning, size: 22),
                ),
                const SizedBox(width: Sp.x4),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('One-Time Unlock',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                      Text('Valid for the rest of today',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sp.x5),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: Sp.x5),
            const Text(
              'You\'ll have full access to this app until midnight. '
              'Purchases are non-refundable and do not carry over to the next day.',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5),
            ),
            const SizedBox(height: Sp.x6),
            FilledButton(
              onPressed: () {
                // TODO: PurchaseService.purchaseUnlock()
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.warning,
              ),
              child: const Text('Purchase — \$0.99',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
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
    );
  }
}
