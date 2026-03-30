import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('AppGate'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusCard(theme: theme),
            const SizedBox(height: 24),
            Text('Quick Actions', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _QuickActionGrid(),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final ThemeData theme;
  const _StatusCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(Icons.lock_outline, size: 40, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Blocking Active', style: theme.textTheme.titleLarge),
                Text('0 apps blocked', style: theme.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.apps, 'Manage Apps', () {}),
      (Icons.timer, 'Time Limits', () {}),
      (Icons.task_alt, 'Tasks', () {}),
      (Icons.settings, 'Settings', () {}),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      physics: const NeverScrollableScrollPhysics(),
      children: actions.map((a) {
        return InkWell(
          onTap: a.$3,
          borderRadius: BorderRadius.circular(12),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(a.$1, size: 32),
                const SizedBox(height: 8),
                Text(a.$2),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
