import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'challenges/breathing_screen.dart';
import 'challenges/focus_timer_screen.dart';
import 'challenges/gratitude_screen.dart';
import 'challenges/quiz_screen.dart';
import 'challenges/walk_screen.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(child: _TaskHeader()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Complete any challenge below to earn an unlock.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'AVAILABLE',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              sliver: SliverList.separated(
                itemCount: _tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) =>
                    _TaskCard(task: _tasks[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────────

class _TaskHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textSecondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Focus Challenges',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

// ── Task definitions ─────────────────────────────────────────────────────────

class _TaskDef {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String duration;
  final String reward;
  final Widget destination;

  const _TaskDef({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.duration,
    required this.reward,
    required this.destination,
  });
}

final _tasks = [
  _TaskDef(
    icon: Icons.timer_rounded,
    color: AppColors.primary,
    title: '5-Minute Focus',
    description:
        'Keep this screen open for 5 minutes without navigating away.',
    duration: '5 min',
    reward: 'Unlock 1 app',
    destination: const FocusTimerScreen(),
  ),
  _TaskDef(
    icon: Icons.self_improvement_rounded,
    color: AppColors.info,
    title: 'Breathing Exercise',
    description: 'Complete three rounds of guided 4-7-8 breathing.',
    duration: '~3 min',
    reward: 'Unlock 1 app',
    destination: const BreathingScreen(),
  ),
  _TaskDef(
    icon: Icons.edit_note_rounded,
    color: AppColors.warning,
    title: 'Gratitude Journal',
    description: 'Write three things you\'re grateful for right now.',
    duration: '2 min',
    reward: 'Unlock 1 app',
    destination: const GratitudeScreen(),
  ),
  _TaskDef(
    icon: Icons.quiz_rounded,
    color: AppColors.primary,
    title: 'Mindfulness Quiz',
    description: 'Answer 3 questions correctly to prove intentionality.',
    duration: '2 min',
    reward: 'Unlock 1 app',
    destination: const QuizScreen(),
  ),
  _TaskDef(
    icon: Icons.directions_walk_rounded,
    color: AppColors.unlocked,
    title: 'Walk 1 km',
    description: 'Step outside and walk a kilometre — tracked via Apple Health.',
    duration: '~10 min',
    reward: 'Unlock 30 min',
    destination: const WalkScreen(),
  ),
];

// ── Task card ─────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final _TaskDef task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => task.destination),
        ),
        borderRadius: BorderRadius.circular(16),
        splashColor: task.color.withValues(alpha: 0.08),
        highlightColor: task.color.withValues(alpha: 0.04),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: task.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(task.icon, color: task.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: task.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            task.duration,
                            style: TextStyle(
                              color: task.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded,
                            size: 13, color: AppColors.unlocked),
                        const SizedBox(width: 4),
                        Text(
                          task.reward,
                          style: const TextStyle(
                            color: AppColors.unlocked,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
