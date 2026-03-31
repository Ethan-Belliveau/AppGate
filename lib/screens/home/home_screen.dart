import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../lock/lock_screen.dart';
import '../pomodoro/pomodoro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _blocking = false;
  // Mock stats — will be wired to real data layer
  final int _appsBlocked = 3;
  final int _minutesSaved = 47;
  final int _unlocksToday = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x4, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _StatusHero(
                  blocking: _blocking,
                  appsBlocked: _appsBlocked,
                  onToggle: (v) => setState(() => _blocking = v),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(child: _StatsRow(
                minutesSaved: _minutesSaved,
                appsBlocked: _appsBlocked,
                unlocks: _unlocksToday,
              )),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x8, Sp.x5, 0),
              sliver: SliverToBoxAdapter(child: _SectionLabel('QUICK ACTIONS')),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, 0),
              sliver: SliverToBoxAdapter(child: _QuickActions(context: context)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x8, Sp.x5, 0),
              sliver: SliverToBoxAdapter(child: _SectionLabel('RECENT ACTIVITY')),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, Sp.x8),
              sliver: SliverToBoxAdapter(child: _RecentActivity()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryMuted,
                borderRadius: BorderRadius.circular(Rr.sm),
              ),
              child: const Icon(Icons.shield_rounded,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: Sp.x3),
            Text('AppGate',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    )),
            const Spacer(),
            _DateChip(),
          ],
        ),
      ),
    );
  }
}

// ── Date chip ────────────────────────────────────────────────────────────────

class _DateChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final label =
        '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Sp.x3, vertical: Sp.x1),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Rr.full),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500)),
    );
  }
}

// ── Status hero ──────────────────────────────────────────────────────────────

class _StatusHero extends StatelessWidget {
  final bool blocking;
  final int appsBlocked;
  final ValueChanged<bool> onToggle;

  const _StatusHero({
    required this.blocking,
    required this.appsBlocked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = blocking ? AppColors.blocked : AppColors.textMuted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Rr.xl),
        border: Border.all(
          color: blocking
              ? AppColors.blocked.withValues(alpha: 0.35)
              : AppColors.border,
        ),
      ),
      padding: const EdgeInsets.all(Sp.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Rr.md),
                ),
                child: Icon(
                  blocking
                      ? Icons.lock_rounded
                      : Icons.lock_open_rounded,
                  color: activeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: Sp.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blocking ? 'Blocking Active' : 'Protection Off',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: Sp.x1),
                    Text(
                      blocking
                          ? '$appsBlocked ${appsBlocked == 1 ? 'app' : 'apps'} blocked right now'
                          : 'All apps are accessible',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Switch(value: blocking, onChanged: onToggle),
            ],
          ),
          if (blocking) ...[
            const SizedBox(height: Sp.x4),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: Sp.x4),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: Sp.x2),
                const Text(
                  'Apps can be unlocked by completing a challenge.',
                  style: TextStyle(
                      color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Stats row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int minutesSaved;
  final int appsBlocked;
  final int unlocks;

  const _StatsRow({
    required this.minutesSaved,
    required this.appsBlocked,
    required this.unlocks,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            value: '${minutesSaved}m',
            label: 'Saved Today',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: Sp.x3),
        Expanded(
          child: _StatTile(
            value: '$appsBlocked',
            label: 'Apps Blocked',
            color: AppColors.blocked,
          ),
        ),
        const SizedBox(width: Sp.x3),
        Expanded(
          child: _StatTile(
            value: '$unlocks',
            label: 'Unlocks Used',
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatTile(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: Sp.x4, horizontal: Sp.x3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Rr.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Quick actions ─────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final BuildContext context;
  const _QuickActions({required this.context});

  @override
  Widget build(BuildContext outerCtx) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.timer_outlined,
            label: 'Start Pomodoro',
            color: AppColors.warning,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const PomodoroScreen(appName: 'Focus Session'),
              ),
            ),
          ),
        ),
        const SizedBox(width: Sp.x3),
        Expanded(
          child: _ActionTile(
            icon: Icons.lock_open_rounded,
            label: 'Demo Lock Screen',
            color: AppColors.blocked,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LockScreen(appName: 'Instagram'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(Rr.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Rr.lg),
        splashColor: color.withValues(alpha: 0.08),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Rr.lg),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(Sp.x4),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Rr.sm),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: Sp.x3),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Recent activity / empty state ────────────────────────────────────────────

class _RecentActivity extends StatelessWidget {
  // Mock data — replace with real unlock/block events
  final List<_ActivityItem> _items = const [
    _ActivityItem(
      icon: Icons.lock_rounded,
      label: 'Instagram blocked',
      time: '2h ago',
      color: AppColors.blocked,
    ),
    _ActivityItem(
      icon: Icons.task_alt_rounded,
      label: 'Unlocked via breathing',
      time: '1h 12m ago',
      color: AppColors.unlocked,
    ),
    _ActivityItem(
      icon: Icons.timer_rounded,
      label: 'Pomodoro session — 25 min',
      time: '45m ago',
      color: AppColors.primary,
    ),
  ];

  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return _emptyState();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Rr.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sp.x4, vertical: Sp.x2),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Rr.sm),
                  ),
                  child: Icon(item.icon, color: item.color, size: 18),
                ),
                title: Text(item.label,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                trailing: Text(item.time,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
              ),
              if (i < _items.length - 1)
                const Divider(
                    height: 1, indent: Sp.x4 + 36 + Sp.x4,
                    color: AppColors.border),
            ],
          );
        }),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(Sp.x8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Rr.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.history_rounded,
              color: AppColors.textMuted, size: 32),
          SizedBox(height: Sp.x3),
          Text('No activity yet',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: Sp.x1),
          Text('Block your first app to get started.',
              style: TextStyle(
                  color: AppColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ActivityItem {
  final IconData icon;
  final String label;
  final String time;
  final Color color;
  const _ActivityItem(
      {required this.icon,
      required this.label,
      required this.time,
      required this.color});
}

// ── Shared section label ──────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }
}
