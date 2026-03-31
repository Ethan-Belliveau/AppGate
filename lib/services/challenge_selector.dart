import 'package:flutter/material.dart';
import '../models/task_difficulty.dart';
import '../screens/tasks/challenges/breathing_screen.dart';
import '../screens/tasks/challenges/focus_timer_screen.dart';
import '../screens/tasks/challenges/gratitude_screen.dart';
import '../screens/tasks/challenges/steps_screen.dart';
import '../screens/tasks/challenges/walk_screen.dart';

/// A single selectable challenge with routing info and metadata.
class ChallengeEntry {
  final String title;
  final String description;
  final String duration;
  final String reward;
  final IconData icon;
  final Color color;
  final TaskDifficulty difficulty;

  /// Builds the destination widget. Called lazily on navigation.
  final Widget Function() builder;

  const ChallengeEntry({
    required this.title,
    required this.description,
    required this.duration,
    required this.reward,
    required this.icon,
    required this.color,
    required this.difficulty,
    required this.builder,
  });
}

/// Selects and orders unlock challenges based on a [RestrictionContext].
///
/// Rules:
///  - Light:    show light challenges only (breathing, 500-step walk)
///  - Moderate: show light + moderate (gratitude, 5-min focus, 1 km walk)
///  - Hard:     show all (10-min focus, 1 km walk, burn calories)
///  - No context (null): show everything sorted by difficulty ascending
abstract final class ChallengeSelector {
  static List<ChallengeEntry> forContext(RestrictionContext? ctx) {
    final all = _allChallenges();
    if (ctx == null) return all;

    final maxLevel = ctx.difficulty.index;
    return all
        .where((c) => c.difficulty.index <= maxLevel)
        .toList();
  }

  static List<ChallengeEntry> _allChallenges() => [
        // ── Light ──────────────────────────────────────────────────────────
        ChallengeEntry(
          title: 'Breathing Exercise',
          description: 'Two rounds of guided 4-7-8 breathing.',
          duration: '~2 min',
          reward: 'Unlock 1 app',
          icon: Icons.self_improvement_rounded,
          color: const Color(0xFF3B82F6),
          difficulty: TaskDifficulty.light,
          builder: () => const BreathingScreen(cycles: 2),
        ),
        ChallengeEntry(
          title: '500-Step Walk',
          description: 'A short walk away from your screen.',
          duration: '~5 min',
          reward: 'Unlock 1 app',
          icon: Icons.directions_walk_rounded,
          color: const Color(0xFF10B981),
          difficulty: TaskDifficulty.light,
          builder: () => const StepsScreen(targetSteps: 500),
        ),

        // ── Moderate ───────────────────────────────────────────────────────
        ChallengeEntry(
          title: 'Gratitude Journal',
          description: 'Write three things you\'re grateful for right now.',
          duration: '~2 min',
          reward: 'Unlock 1 app',
          icon: Icons.edit_note_rounded,
          color: const Color(0xFFF59E0B),
          difficulty: TaskDifficulty.moderate,
          builder: () => const GratitudeScreen(),
        ),
        ChallengeEntry(
          title: '5-Minute Focus',
          description: 'Keep this screen open without navigating away.',
          duration: '5 min',
          reward: 'Unlock 1 app',
          icon: Icons.timer_rounded,
          color: const Color(0xFF6366F1),
          difficulty: TaskDifficulty.moderate,
          builder: () => const FocusTimerScreen(durationMinutes: 5),
        ),
        ChallengeEntry(
          title: 'Walk 1 km',
          description: 'Step outside and walk a full kilometre.',
          duration: '~10 min',
          reward: 'Unlock 30 min',
          icon: Icons.route_rounded,
          color: const Color(0xFF10B981),
          difficulty: TaskDifficulty.moderate,
          builder: () => const WalkScreen(targetMetres: 1000),
        ),

        // ── Hard ───────────────────────────────────────────────────────────
        ChallengeEntry(
          title: '10-Minute Focus',
          description: 'Stay fully present on this screen for ten minutes.',
          duration: '10 min',
          reward: 'Unlock 1 app',
          icon: Icons.timer_outlined,
          color: const Color(0xFF6366F1),
          difficulty: TaskDifficulty.hard,
          builder: () => const FocusTimerScreen(durationMinutes: 10),
        ),
        ChallengeEntry(
          title: 'Breathing — Full Session',
          description: 'Four complete rounds of 4-7-8 breathing.',
          duration: '~5 min',
          reward: 'Unlock 1 app',
          icon: Icons.air_rounded,
          color: const Color(0xFF3B82F6),
          difficulty: TaskDifficulty.hard,
          builder: () => const BreathingScreen(cycles: 4),
        ),
        ChallengeEntry(
          title: 'Walk 2 km',
          description: 'A proper walk — two kilometres tracked via Apple Health.',
          duration: '~20 min',
          reward: 'Unlock the day',
          icon: Icons.landscape_rounded,
          color: const Color(0xFF10B981),
          difficulty: TaskDifficulty.hard,
          builder: () => const WalkScreen(targetMetres: 2000),
        ),
      ];
}
