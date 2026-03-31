import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  bool _blockAll = true;

  // Mock stats
  static const _focusScore = 0.73;
  static const _minutesSaved = 47;
  static const _streakDays = 5;
  static const _appsBlocked = 3;

  static const _blockedApps = [
    ('Instagram', Color(0xFFE1306C)),
    ('TikTok', Color(0xFF69C9D0)),
    ('Reddit', Color(0xFFFF4500)),
  ];

  static const _activityItems = [
    (Icons.lock_rounded, 'Instagram blocked', '2h ago', AppColors.blocked),
    (Icons.task_alt_rounded, 'Breathing exercise completed', '1h 12m ago', AppColors.unlocked),
    (Icons.bolt_rounded, 'TikTok unlocked via task', '45m ago', AppColors.primary),
    (Icons.lock_rounded, 'Reddit blocked', '20m ago', AppColors.blocked),
  ];

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(context, greeting),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _FocusRingHero(
                  score: _focusScore,
                  minutesSaved: _minutesSaved,
                  streakDays: _streakDays,
                  appsBlocked: _appsBlocked,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x4, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _BlockAllToggle(
                  active: _blockAll,
                  appsBlocked: _appsBlocked,
                  onChanged: (v) => setState(() => _blockAll = v),
                ),
              ),
            ),
            if (_blockAll) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, 0, 0),
                sliver: SliverToBoxAdapter(
                  child: _BlockedAppsScroll(apps: _blockedApps),
                ),
              ),
            ],
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(child: _SectionLabel('RECENT ACTIVITY')),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, Sp.x12),
              sliver: SliverToBoxAdapter(
                child: _RecentActivityCard(items: _activityItems),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String greeting) {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dateStr = '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: Sp.x1),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rr.md),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25)),
              ),
              child: const Icon(Icons.shield_rounded,
                  color: AppColors.primary, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Focus Ring Hero ───────────────────────────────────────────────────────────

class _FocusRingHero extends StatelessWidget {
  final double score;
  final int minutesSaved;
  final int streakDays;
  final int appsBlocked;

  const _FocusRingHero({
    required this.score,
    required this.minutesSaved,
    required this.streakDays,
    required this.appsBlocked,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.xxl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(Sp.x6),
          decoration: BoxDecoration(
            color: AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(Rr.xxl),
            border: Border.all(color: AppColors.glassStroke, width: 0.5),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 188,
                height: 188,
                child: CustomPaint(
                  painter: _RingPainter(progress: score),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(score * 100).round()}%',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -2,
                          ),
                        ),
                        const Text(
                          'Focus Score',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Sp.x5),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MiniStat(
                        value: '${minutesSaved}m', label: 'Saved today'),
                    _VertDivider(),
                    _MiniStat(
                        value: '$appsBlocked', label: 'Apps blocked'),
                    _VertDivider(),
                    _MiniStat(
                        value: '$streakDays day', label: 'Streak 🔥'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 0.5,
        color: AppColors.glassStroke,
      );
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;

  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 14;
    const strokeWidth = 14.0;
    const startAngle = -math.pi / 2; // 12 o'clock

    // Track ring
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      math.pi * 2,
      false,
      Paint()
        ..color = const Color(0x1AFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    if (progress <= 0) return;

    // Progress arc with gradient
    final sweepAngle = math.pi * 2 * progress;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: const [AppColors.primary, Color(0xFFA78BFF)],
    );

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ── Block All Toggle ──────────────────────────────────────────────────────────

class _BlockAllToggle extends StatelessWidget {
  final bool active;
  final int appsBlocked;
  final ValueChanged<bool> onChanged;

  const _BlockAllToggle({
    required this.active,
    required this.appsBlocked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary.withValues(alpha: 0.10)
            : AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(Rr.xl),
        border: Border.all(
          color: active
              ? AppColors.primary.withValues(alpha: 0.40)
              : AppColors.glassStroke,
          width: active ? 1.0 : 0.5,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 28,
                  spreadRadius: -4,
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: Sp.x5, vertical: Sp.x4),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withValues(alpha: 0.18)
                  : const Color(0x12FFFFFF),
              borderRadius: BorderRadius.circular(Rr.md),
            ),
            child: Icon(
              active ? Icons.shield_rounded : Icons.shield_outlined,
              color: active ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
          ),
          const SizedBox(width: Sp.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  active ? 'Block All' : 'Blocking Off',
                  style: TextStyle(
                    color: active ? AppColors.primary : AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  active
                      ? '$appsBlocked apps blocked — complete a task to unlock'
                      : 'All apps are freely accessible',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: active, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ── Blocked Apps Horizontal Scroll ────────────────────────────────────────────

class _BlockedAppsScroll extends StatelessWidget {
  final List<(String, Color)> apps;

  const _BlockedAppsScroll({required this.apps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: Sp.x3, right: Sp.x5),
          child: _SectionLabel('CURRENTLY BLOCKING'),
        ),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: Sp.x5),
            itemCount: apps.length,
            separatorBuilder: (_, __) => const SizedBox(width: Sp.x3),
            itemBuilder: (_, i) {
              final (name, color) = apps[i];
              return Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(Rr.md),
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        name[0].toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Sp.x1 + 2),
                  Text(
                    name.length > 7 ? '${name.substring(0, 6)}…' : name,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Recent Activity Card ──────────────────────────────────────────────────────

class _RecentActivityCard extends StatelessWidget {
  final List<(IconData, String, String, Color)> items;

  const _RecentActivityCard({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return _emptyState();

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
            children: List.generate(items.length, (i) {
              final (icon, label, time, color) = items[i];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Sp.x4, vertical: Sp.x3),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(Rr.sm),
                          ),
                          child: Icon(icon, color: color, size: 17),
                        ),
                        const SizedBox(width: Sp.x3),
                        Expanded(
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < items.length - 1)
                    const Divider(
                      height: 0.5,
                      indent: Sp.x4 + 36 + Sp.x3,
                      color: AppColors.glassStroke,
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(Sp.x8),
          decoration: BoxDecoration(
            color: AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(Rr.xl),
            border: Border.all(color: AppColors.glassStroke, width: 0.5),
          ),
          child: const Column(
            children: [
              Icon(Icons.history_rounded, color: AppColors.textMuted, size: 32),
              SizedBox(height: Sp.x3),
              Text(
                'No activity yet',
                style: TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: Sp.x1),
              Text(
                'Block your first app to get started.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
