import 'package:flutter/material.dart';

/// Shown when the user attempts to open a blocked app.
/// Offers two unlock paths: complete a task or pay via IAP.
class LockScreen extends StatelessWidget {
  final String appName;

  const LockScreen({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  appName,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'This app is blocked.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                FilledButton.icon(
                  onPressed: () {
                    // TODO: navigate to TaskScreen
                  },
                  icon: const Icon(Icons.task_alt),
                  label: const Text('Complete a Task to Unlock'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: trigger PurchaseService.purchaseUnlock
                  },
                  icon: const Icon(Icons.monetization_on_outlined),
                  label: const Text('Unlock Once (Purchase)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
