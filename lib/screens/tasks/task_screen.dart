import 'package:flutter/material.dart';

/// Lists available focus tasks and lets the user start one to earn an unlock.
class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Challenges')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _TaskCard(
            icon: Icons.timer,
            title: '5-Minute Focus',
            description: 'Stay on this screen for 5 minutes without leaving.',
          ),
          _TaskCard(
            icon: Icons.self_improvement,
            title: 'Breathing Exercise',
            description: 'Complete a guided 4-7-8 breathing session.',
          ),
          _TaskCard(
            icon: Icons.quiz,
            title: 'Quick Quiz',
            description: 'Answer 3 mindfulness questions correctly.',
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TaskCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: start task and observe completion
        },
      ),
    );
  }
}
