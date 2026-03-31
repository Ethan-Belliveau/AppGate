import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/task_difficulty.dart';
import '../../services/challenge_selector.dart';

class TaskScreen extends StatelessWidget {
  /// When provided, filters challenges to those appropriate for this context.
  final RestrictionContext? restrictionContext;

  const TaskScreen({super.key, this.restrictionContext});

  @override
  Widget build(BuildContext context) {
    final challenges = ChallengeSelector.forContext(restrictionContext);
    final diff = restrictionContext?.difficulty;

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
                child: diff != null
                    ? _DifficultyBanner(difficulty: diff, context: restrictionContext!)
                    : Text(
                        'Complete any challenge to earn an unlock.',
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
                itemCount: challenges.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) =>
                    _TaskCard(entry: challenges[i]),
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

// ── Difficulty context banner ────────────────────────────────────────────────

class _DifficultyBanner extends StatelessWidget {
  final TaskDifficulty difficulty;
  final RestrictionContext context;

  const _DifficultyBanner(
      {required this.difficulty, required this.context});

  @override
  Widget build(BuildContext ctx) {
    final (label, color, icon) = switch (difficulty) {
      TaskDifficulty.light => (
          'Light challenge required',
          AppColors.unlocked,
          Icons.bolt_rounded
        ),
      TaskDifficulty.moderate => (
          'Moderate challenge required',
          AppColors.warning,
          Icons.local_fire_department_rounded
        ),
      TaskDifficulty.hard => (
          'Serious challenge required',
          AppColors.blocked,
          Icons.fitness_center_rounded
        ),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                Text(
                  '${context.timeLimitMinutes ~/ 60}h limit · ${context.breakLabel}',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Task card ─────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final ChallengeEntry entry;
  const _TaskCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => entry.builder()),
        ),
        borderRadius: BorderRadius.circular(16),
        splashColor: entry.color.withValues(alpha: 0.08),
        highlightColor: entry.color.withValues(alpha: 0.04),
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
                  color: entry.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(entry.icon, color: entry.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.title,
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
                            color: entry.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            entry.duration,
                            style: TextStyle(
                              color: entry.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.description,
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
                          entry.reward,
                          style: const TextStyle(
                            color: AppColors.unlocked,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _DifficultyPill(difficulty: entry.difficulty),
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

class _DifficultyPill extends StatelessWidget {
  final TaskDifficulty difficulty;
  const _DifficultyPill({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (difficulty) {
      TaskDifficulty.light => ('Easy', AppColors.unlocked),
      TaskDifficulty.moderate => ('Medium', AppColors.warning),
      TaskDifficulty.hard => ('Hard', AppColors.blocked),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
