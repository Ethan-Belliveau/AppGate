import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/task_difficulty.dart';
import '../../services/challenge_selector.dart';

class TaskScreen extends StatelessWidget {
  final RestrictionContext? restrictionContext;

  const TaskScreen({super.key, this.restrictionContext});

  @override
  Widget build(BuildContext context) {
    final all = ChallengeSelector.forContext(null); // show all, grouped
    final easy = all.where((c) => c.difficulty == TaskDifficulty.light).toList();
    final medium = all.where((c) => c.difficulty == TaskDifficulty.moderate).toList();
    final hard = all.where((c) => c.difficulty == TaskDifficulty.hard).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(context),
            if (restrictionContext != null)
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(Sp.x5, Sp.x4, Sp.x5, 0),
                sliver: SliverToBoxAdapter(
                  child: _ContextBanner(ctx: restrictionContext!),
                ),
              ),
            _buildGroup(context, 'EASY', easy),
            _buildGroup(context, 'MEDIUM', medium),
            _buildGroup(context, 'HARD', hard),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: Sp.x8),
              sliver: SliverToBoxAdapter(child: SizedBox()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final fromLock = restrictionContext != null ||
        Navigator.of(context).canPop();
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            if (Navigator.of(context).canPop()) ...[
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textSecondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Rr.sm)),
                ),
              ),
              const SizedBox(width: Sp.x3),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Challenges',
                    style:
                        Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            )),
                Text(
                  fromLock
                      ? 'Complete one to earn an unlock'
                      : 'Build habits, earn unlocks',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(
      BuildContext context, String label, List<ChallengeEntry> items) {
    if (items.isEmpty) return const SliverToBoxAdapter(child: SizedBox());
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupHeader(label: label, count: items.length),
            const SizedBox(height: Sp.x3),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(Rr.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: List.generate(items.length, (i) {
                  return Column(
                    children: [
                      _ChallengeRow(entry: items[i]),
                      if (i < items.length - 1)
                        const Divider(
                          height: 1,
                          indent: Sp.x5 + 44 + Sp.x4,
                          color: AppColors.border,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Group header ──────────────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  final String label;
  final int count;
  const _GroupHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final color = switch (label) {
      'EASY' => AppColors.unlocked,
      'MEDIUM' => AppColors.warning,
      _ => AppColors.blocked,
    };
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(width: Sp.x2),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: Sp.x2, vertical: 1),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Rr.full),
          ),
          child: Text(
            '$count',
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

// ── Challenge row ─────────────────────────────────────────────────────────────

class _ChallengeRow extends StatelessWidget {
  final ChallengeEntry entry;
  const _ChallengeRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => entry.builder()),
      ),
      borderRadius: BorderRadius.circular(Rr.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Sp.x5, vertical: Sp.x3 + 2),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: entry.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Rr.sm + 2),
              ),
              child: Icon(entry.icon, color: entry.color, size: 22),
            ),
            const SizedBox(width: Sp.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(entry.duration,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted)),
                      const Text(' · ',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      Text(entry.reward,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.unlocked,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Context banner (when launched from lock screen) ───────────────────────────

class _ContextBanner extends StatelessWidget {
  final RestrictionContext ctx;
  const _ContextBanner({required this.ctx});

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (ctx.difficulty) {
      TaskDifficulty.light => (
          'An easy challenge will unlock this app',
          AppColors.unlocked,
          Icons.bolt_rounded
        ),
      TaskDifficulty.moderate => (
          'A medium challenge is required',
          AppColors.warning,
          Icons.local_fire_department_rounded
        ),
      TaskDifficulty.hard => (
          'A serious challenge is required',
          AppColors.blocked,
          Icons.fitness_center_rounded
        ),
    };

    return Container(
      padding: const EdgeInsets.all(Sp.x4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Rr.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: Sp.x3),
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
                  '${ctx.timeLimitMinutes ~/ 60}h limit · ${ctx.breakLabel}',
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
