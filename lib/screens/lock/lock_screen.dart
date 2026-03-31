import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../tasks/task_screen.dart';

/// The gate screen shown when a user attempts to open a blocked app.
class LockScreen extends StatelessWidget {
  final String appName;

  const LockScreen({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _BackButton(),
              const Spacer(),
              _LockIcon(),
              const SizedBox(height: 28),
              _AppLabel(appName: appName),
              const SizedBox(height: 12),
              _BlockedMessage(),
              const Spacer(),
              _UnlockOptions(appName: appName),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _LockIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.blocked.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.blocked.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.lock_rounded,
          color: AppColors.blocked,
          size: 40,
        ),
      ),
    );
  }
}

class _AppLabel extends StatelessWidget {
  final String appName;
  const _AppLabel({required this.appName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          appName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.blocked.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.blocked.withValues(alpha: 0.3)),
          ),
          child: const Text(
            'BLOCKED',
            style: TextStyle(
              color: AppColors.blocked,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _BlockedMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'You set this app as off-limits.\nComplete a focus challenge or unlock once to proceed.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
    );
  }
}

class _UnlockOptions extends StatelessWidget {
  final String appName;
  const _UnlockOptions({required this.appName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskScreen()),
          ),
          icon: const Icon(Icons.task_alt_rounded, size: 18),
          label: const Text('Complete a Challenge'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: trigger PurchaseService.purchaseUnlock
            _showPurchaseSheet(context);
          },
          icon: const Icon(Icons.bolt_rounded, size: 18),
          label: const Text('Unlock Once — \$0.99'),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text(
              'Go back',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  void _showPurchaseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'One-Time Unlock',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pay \$0.99 to unlock this app for the rest of the day.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Purchase — \$0.99'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
