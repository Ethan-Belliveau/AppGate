import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/app_tier.dart';
import '../../models/task_difficulty.dart';
import '../../services/challenge_selector.dart';
import '../../theme/tier_badge.dart';

/// Maps task difficulty to the tier system for display grouping.
AppTier _tierFromDifficulty(TaskDifficulty d) => switch (d) {
      TaskDifficulty.light => AppTier.short,
      TaskDifficulty.moderate => AppTier.normal,
      TaskDifficulty.hard => AppTier.long,
    };

class TaskScreen extends StatefulWidget {
  final RestrictionContext? restrictionContext;

  const TaskScreen({super.key, this.restrictionContext});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  // Mock: one completed task
  final Set<String> _completedTitles = {'Breathing Exercise'};

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = ChallengeSelector.forContext(null);
    final available =
        all.where((c) => !_completedTitles.contains(c.title)).toList();
    final completed =
        all.where((c) => _completedTitles.contains(c.title)).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: Sp.x4),
            _buildTabBar(context),
            const SizedBox(height: Sp.x4),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _AvailableTab(
                    tasks: available,
                    onComplete: (title) =>
                        setState(() => _completedTitles.add(title)),
                  ),
                  _CompletedTab(tasks: completed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tasks', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 2),
          const Text(
            'Complete tasks to earn unlock tokens',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.x5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Rr.full),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: BorderRadius.circular(Rr.full),
              border: Border.all(color: AppColors.glassStroke, width: 0.5),
            ),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(Rr.full),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Available'),
                Tab(text: 'Completed Today'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Available tab ─────────────────────────────────────────────────────────────

class _AvailableTab extends StatelessWidget {
  final List<ChallengeEntry> tasks;
  final void Function(String title) onComplete;

  const _AvailableTab({required this.tasks, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const _AllDoneState();
    }

    final shortTasks =
        tasks.where((t) => t.difficulty == TaskDifficulty.light).toList();
    final normalTasks =
        tasks.where((t) => t.difficulty == TaskDifficulty.moderate).toList();
    final longTasks =
        tasks.where((t) => t.difficulty == TaskDifficulty.hard).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(Sp.x5, 0, Sp.x5, Sp.x12),
      children: [
        if (shortTasks.isNotEmpty) ...[
          _TierGroupHeader(tier: AppTier.short, count: shortTasks.length),
          const SizedBox(height: Sp.x3),
          _TaskGroup(tasks: shortTasks, onComplete: onComplete),
          const SizedBox(height: Sp.x5),
        ],
        if (normalTasks.isNotEmpty) ...[
          _TierGroupHeader(tier: AppTier.normal, count: normalTasks.length),
          const SizedBox(height: Sp.x3),
          _TaskGroup(tasks: normalTasks, onComplete: onComplete),
          const SizedBox(height: Sp.x5),
        ],
        if (longTasks.isNotEmpty) ...[
          _TierGroupHeader(tier: AppTier.long, count: longTasks.length),
          const SizedBox(height: Sp.x3),
          _TaskGroup(tasks: longTasks, onComplete: onComplete),
        ],
      ],
    );
  }
}

// ── Completed tab ─────────────────────────────────────────────────────────────

class _CompletedTab extends StatelessWidget {
  final List<ChallengeEntry> tasks;

  const _CompletedTab({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Sp.x8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDim,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.glassStroke, width: 0.5),
                ),
                child: const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.textMuted, size: 30),
              ),
              const SizedBox(height: Sp.x4),
              const Text(
                'Nothing completed yet',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: Sp.x2),
              const Text(
                'Finish a task from the Available tab\nto earn your first unlock token.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(Sp.x5, 0, Sp.x5, Sp.x12),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: Sp.x3),
      itemBuilder: (_, i) => _TaskCard(
        entry: tasks[i],
        completed: true,
        onComplete: null,
      ),
    );
  }
}

// ── Tier group header ─────────────────────────────────────────────────────────

class _TierGroupHeader extends StatelessWidget {
  final AppTier tier;
  final int count;

  const _TierGroupHeader({required this.tier, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TierBadge(tier: tier),
        const SizedBox(width: Sp.x2),
        Text(
          tier.taskDuration,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Sp.x2 + 2, vertical: 2),
          decoration: BoxDecoration(
            color: tier.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Rr.full),
          ),
          child: Text(
            '$count task${count != 1 ? 's' : ''}',
            style: TextStyle(
              color: tier.color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Task group card ───────────────────────────────────────────────────────────

class _TaskGroup extends StatelessWidget {
  final List<ChallengeEntry> tasks;
  final void Function(String) onComplete;

  const _TaskGroup({required this.tasks, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(Rr.xl),
            border: Border.all(color: AppColors.glassStroke, width: 0.5),
          ),
          child: Column(
            children: List.generate(tasks.length, (i) {
              return Column(
                children: [
                  _TaskCard(
                    entry: tasks[i],
                    completed: false,
                    onComplete: () => onComplete(tasks[i].title),
                    inGroup: true,
                  ),
                  if (i < tasks.length - 1)
                    const Divider(
                        height: 0.5,
                        indent: Sp.x5 + 44 + Sp.x4,
                        color: AppColors.glassStroke),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Task card ─────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final ChallengeEntry entry;
  final bool completed;
  final VoidCallback? onComplete;
  final bool inGroup;

  const _TaskCard({
    required this.entry,
    required this.completed,
    required this.onComplete,
    this.inGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    final tier = _tierFromDifficulty(entry.difficulty);

    Widget card = Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Sp.x5, vertical: Sp.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: entry.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(Rr.md),
            ),
            child: Icon(entry.icon, color: entry.color, size: 22),
          ),
          const SizedBox(width: Sp.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.title,
                        style: TextStyle(
                          color: completed
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    if (completed)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.unlocked, size: 18),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    TierBadge(tier: tier, compact: true),
                    const SizedBox(width: Sp.x2),
                    Text(
                      entry.duration,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: Sp.x2),
                Text(
                  entry.description,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4),
                ),
                if (!completed) ...[
                  const SizedBox(height: Sp.x3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => entry.builder()),
                        ).then((_) => onComplete?.call());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Sp.x4, vertical: Sp.x2),
                        decoration: BoxDecoration(
                          color: entry.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(Rr.full),
                          border: Border.all(
                              color: entry.color.withValues(alpha: 0.35),
                              width: 0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow_rounded,
                                color: entry.color, size: 14),
                            const SizedBox(width: Sp.x1),
                            Text(
                              'Start',
                              style: TextStyle(
                                color: entry.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    // If not in a group, wrap with its own glass card
    if (!inGroup) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Rr.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: BorderRadius.circular(Rr.xl),
              border:
                  Border.all(color: AppColors.glassStroke, width: 0.5),
            ),
            child: card,
          ),
        ),
      );
    }

    return card;
  }
}

// ── All done empty state ──────────────────────────────────────────────────────

class _AllDoneState extends StatelessWidget {
  const _AllDoneState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sp.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.unlocked.withValues(alpha: 0.10),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.unlocked.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.verified_rounded,
                  color: AppColors.unlocked, size: 34),
            ),
            const SizedBox(height: Sp.x5),
            const Text(
              'All done for today!',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: Sp.x2),
            const Text(
              'You\'ve completed all available tasks.\nCheck back tomorrow for more.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
