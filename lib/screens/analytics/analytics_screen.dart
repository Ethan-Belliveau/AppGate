import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/app_tier.dart';
import '../../state/blocked_apps_notifier.dart';
import '../../theme/glass_card.dart';
import '../apps/app_logo.dart';
import '../lock/lock_screen.dart';

// ── Mock screen-time data (hours) ─────────────────────────────────────────────

class _DayData {
  final String label;
  final double hours;
  const _DayData(this.label, this.hours);
}

class _AppUsage {
  final String name;
  final String? logoUrl;
  final int minutes;
  const _AppUsage(this.name, this.logoUrl, this.minutes);
}

const _weeklyHours = [
  _DayData('Mon', 3.1),
  _DayData('Tue', 4.0),
  _DayData('Wed', 2.8),
  _DayData('Thu', 5.2),
  _DayData('Fri', 4.6),
  _DayData('Sat', 7.0),
  _DayData('Sun', 1.9), // today (in progress)
];

const _mostUsed = [
  _AppUsage('TikTok',
      'https://sf16-website-login.neutral.ttwstatic.com/obj/tiktok_web_login_static/tiktok/webapp/main/webapp-desktop/8152caf0c8e8bc67ae0d.png',
      102),
  _AppUsage('YouTube',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/159px-YouTube_full-color_icon_%282017%29.svg.png',
      75),
  _AppUsage('Instagram',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/132px-Instagram_logo_2016.svg.png',
      58),
  _AppUsage('Reddit',
      'https://www.redditinc.com/assets/images/site/reddit-logo.png',
      32),
];

String _fmt(int minutes) {
  if (minutes >= 60) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
  return '${minutes}m';
}

// ── Screen ────────────────────────────────────────────────────────────────────

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  double get _dailyAvg {
    final total = _weeklyHours.fold(0.0, (s, d) => s + d.hours);
    return total / _weeklyHours.length;
  }

  double get _weekTotal =>
      _weeklyHours.fold(0.0, (s, d) => s + d.hours);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final labelColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dashboard',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text("Today's overview",
                        style: TextStyle(color: subColor, fontSize: 13)),
                  ],
                ),
              ),
            ),

            // ── Stat chips ───────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: ValueListenableBuilder(
                  valueListenable: BlockedAppsNotifier.notifier,
                  builder: (_, apps, __) => GlassCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Sp.x5, vertical: Sp.x4),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatChip(
                              label: 'Saved Today',
                              value: '48m',
                              color: AppColors.tierShort,
                            ),
                          ),
                          _VertDivider(),
                          Expanded(
                            child: _StatChip(
                              label: 'Apps Blocked',
                              value: '${apps.length}',
                              color: AppColors.primary,
                            ),
                          ),
                          _VertDivider(),
                          Expanded(
                            child: _StatChip(
                              label: 'Unlocks Used',
                              value: '1',
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Pomodoro timer ────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x4, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: GlassCard(
                  padding: const EdgeInsets.fromLTRB(
                      Sp.x5, Sp.x4, Sp.x5, Sp.x4),
                  child: const _PomodoroWidget(),
                ),
              ),
            ),

            // ── Demo lock screen button ───────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LockScreen(
                        appName: 'Instagram',
                        appLogoUrl:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/132px-Instagram_logo_2016.svg.png',
                        tier: AppTier.normal,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.lock_open_rounded, size: 16),
                  label: const Text('Demo Lock Screen'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                ),
              ),
            ),

            // ── Screen Time section label ────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      'SCREEN TIME',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: Sp.x2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sp.x2, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(Rr.full),
                        border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                            width: 0.5),
                      ),
                      child: const Text(
                        'mock data',
                        style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 9,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bar chart card ───────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: GlassCard(
                  padding: const EdgeInsets.fromLTRB(
                      Sp.x5, Sp.x5, Sp.x5, Sp.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Past 7 days',
                        style: TextStyle(
                          color: subColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: Sp.x4),
                      SizedBox(
                        height: 160,
                        child: _BarChart(data: _weeklyHours),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Daily avg + Week total chips ─────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sp.x5, vertical: Sp.x4),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatChip(
                            label: 'Daily avg',
                            value:
                                '${_dailyAvg.toStringAsFixed(1)}h',
                            color: AppColors.primary,
                          ),
                        ),
                        _VertDivider(),
                        Expanded(
                          child: _StatChip(
                            label: 'Week total',
                            value:
                                '${_weekTotal.toStringAsFixed(1)}h',
                            color: AppColors.tierNormal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Most Used section label ──────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'MOST USED TODAY',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),

            // ── Most Used list ───────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: GlassCard(
                  child: Column(
                    children: List.generate(_mostUsed.length, (i) {
                      final app = _mostUsed[i];
                      final maxMin = _mostUsed.first.minutes;
                      return Column(
                        children: [
                          _MostUsedRow(
                            app: app,
                            fraction: app.minutes / maxMin,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          if (i < _mostUsed.length - 1)
                            Divider(
                              height: 0.5,
                              indent: Sp.x5 + 44 + Sp.x4,
                              color: isDark
                                  ? AppColors.glassStroke
                                  : AppColors.lightGlassStroke,
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),

            // ── Mock data disclaimer ─────────────────────────────────────────
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(Sp.x5, Sp.x4, Sp.x5, Sp.x12),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'Mock data — connect your device in Settings',
                    style: TextStyle(color: mutedColor, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pomodoro widget ───────────────────────────────────────────────────────────

enum _Phase { work, shortBreak, longBreak }

enum _Status { idle, running, paused }

class _PomodoroWidget extends StatefulWidget {
  const _PomodoroWidget();

  @override
  State<_PomodoroWidget> createState() => _PomodoroWidgetState();
}

class _PomodoroWidgetState extends State<_PomodoroWidget> {
  _Phase _phase = _Phase.work;
  _Status _status = _Status.idle;
  int _secondsLeft = 25 * 60;
  int _sessionsDone = 0;
  Timer? _timer;

  int get _totalSeconds => switch (_phase) {
        _Phase.work => 25 * 60,
        _Phase.shortBreak => 5 * 60,
        _Phase.longBreak => 15 * 60,
      };

  String get _phaseLabel => switch (_phase) {
        _Phase.work => 'Focus',
        _Phase.shortBreak => 'Short Break',
        _Phase.longBreak => 'Long Break',
      };

  String get _timeString {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress => 1.0 - _secondsLeft / _totalSeconds;

  void _start() {
    setState(() => _status = _Status.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        _advancePhase();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _status = _Status.paused);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _status = _Status.idle;
      _secondsLeft = _totalSeconds;
    });
  }

  void _advancePhase() {
    if (_phase == _Phase.work) {
      final sessions = _sessionsDone + 1;
      setState(() {
        _sessionsDone = sessions;
        if (sessions % 4 == 0) {
          _phase = _Phase.longBreak;
          _secondsLeft = 15 * 60;
        } else {
          _phase = _Phase.shortBreak;
          _secondsLeft = 5 * 60;
        }
        _status = _Status.idle;
      });
    } else {
      setState(() {
        _phase = _Phase.work;
        _secondsLeft = 25 * 60;
        _status = _Status.idle;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final phaseColor = _phase == _Phase.work
        ? AppColors.primary
        : AppColors.tierShort;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phase label row
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: phaseColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: Sp.x2),
            Text(
              _phaseLabel,
              style: TextStyle(
                color: phaseColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              'Pomodoro',
              style: TextStyle(color: mutedColor, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: Sp.x3),
        // Time display
        Text(
          _timeString,
          style: TextStyle(
            color: textColor,
            fontSize: 40,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: Sp.x3),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(Rr.full),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 4,
            backgroundColor: isDark
                ? const Color(0x1AFFFFFF)
                : const Color(0x1A000000),
            valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
          ),
        ),
        const SizedBox(height: Sp.x4),
        // Session dots + controls
        Row(
          children: [
            // Session dots (4 per cycle)
            ...List.generate(4, (i) {
              final done = i < (_sessionsDone % 4);
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: done
                        ? AppColors.primary
                        : (isDark
                            ? const Color(0x26FFFFFF)
                            : const Color(0x26000000)),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
            const Spacer(),
            // Reset button
            if (_status != _Status.idle)
              Padding(
                padding: const EdgeInsets.only(right: Sp.x2),
                child: GestureDetector(
                  onTap: _reset,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0x14FFFFFF)
                          : const Color(0x14000000),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.refresh_rounded,
                        color: mutedColor, size: 16),
                  ),
                ),
              ),
            // Start / Pause button
            GestureDetector(
              onTap: _status == _Status.running ? _pause : _start,
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: Sp.x4),
                decoration: BoxDecoration(
                  color: phaseColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(Rr.full),
                  border: Border.all(
                      color: phaseColor.withValues(alpha: 0.4), width: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _status == _Status.running
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: phaseColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _status == _Status.running
                          ? 'Pause'
                          : (_status == _Status.paused ? 'Resume' : 'Start'),
                      style: TextStyle(
                        color: phaseColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Bar chart ─────────────────────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final List<_DayData> data;

  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      painter: _BarChartPainter(
        data: data,
        isDark: isDark,
        primaryColor: AppColors.primary,
        mutedColor: isDark
            ? const Color(0x26FFFFFF)
            : const Color(0x26000000),
        labelColor: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
        gridColor: isDark
            ? const Color(0x0FFFFFFF)
            : const Color(0x0F000000),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<_DayData> data;
  final bool isDark;
  final Color primaryColor;
  final Color mutedColor;
  final Color labelColor;
  final Color gridColor;

  const _BarChartPainter({
    required this.data,
    required this.isDark,
    required this.primaryColor,
    required this.mutedColor,
    required this.labelColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal =
        data.map((d) => d.hours).reduce(math.max).toDouble();
    const labelH = 20.0;
    const barRadius = Radius.circular(6);
    final chartH = size.height - labelH;
    final barW = (size.width / data.length) * 0.55;
    final gap = (size.width / data.length) * 0.45;

    // Grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    for (var i = 1; i <= 3; i++) {
      final y = chartH * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Bars
    for (var i = 0; i < data.length; i++) {
      final isToday = i == data.length - 1;
      final frac = data[i].hours / maxVal;
      final barH = (chartH - 4) * frac;
      final left = i * (size.width / data.length) + gap / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, chartH - barH, barW, barH),
        barRadius,
      );

      if (isToday) {
        final shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.6),
          ],
        ).createShader(Rect.fromLTWH(left, chartH - barH, barW, barH));
        canvas.drawRRect(rect, Paint()
          ..shader = shader
          ..style = PaintingStyle.fill);
        canvas.drawRRect(
            rect,
            Paint()
              ..color = primaryColor.withValues(alpha: 0.18)
              ..maskFilter =
                  const MaskFilter.blur(BlurStyle.normal, 8));
      } else {
        canvas.drawRRect(rect, Paint()..color = mutedColor);
      }

      // Label
      final tp = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style: TextStyle(
            color: isToday ? primaryColor : labelColor,
            fontSize: 10,
            fontWeight:
                isToday ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(left + barW / 2 - tp.width / 2, chartH + 6));
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.data != data || old.isDark != isDark;
}

// ── Stat chip ─────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 0.5,
      height: 40,
      color: isDark ? AppColors.glassStroke : AppColors.lightGlassStroke,
    );
  }
}

// ── Most used row ─────────────────────────────────────────────────────────────

class _MostUsedRow extends StatelessWidget {
  final _AppUsage app;
  final double fraction;
  final Color textColor;
  final Color subColor;

  const _MostUsedRow({
    required this.app,
    required this.fraction,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Sp.x5, vertical: Sp.x3 + 2),
      child: Row(
        children: [
          AppLogo(url: app.logoUrl, name: app.name, size: 44, borderRadius: 10),
          const SizedBox(width: Sp.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.name,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                LayoutBuilder(builder: (_, c) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(Rr.full),
                    child: Stack(
                      children: [
                        Container(
                          height: 4,
                          width: c.maxWidth,
                          color: isDark
                              ? const Color(0x1AFFFFFF)
                              : const Color(0x1A000000),
                        ),
                        Container(
                          height: 4,
                          width: c.maxWidth * fraction,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(Rr.full),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: Sp.x4),
          Text(
            _fmt(app.minutes),
            style: TextStyle(
              color: subColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
