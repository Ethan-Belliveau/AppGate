import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../theme/glass_card.dart';
import '../apps/app_logo.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

class _DayData {
  final String label;
  final int minutes;
  const _DayData(this.label, this.minutes);
}

class _AppUsage {
  final String name;
  final String? logoUrl;
  final int minutes;
  const _AppUsage(this.name, this.logoUrl, this.minutes);
}

const _weeklyData = [
  _DayData('Mon', 185),
  _DayData('Tue', 242),
  _DayData('Wed', 168),
  _DayData('Thu', 310),
  _DayData('Fri', 275),
  _DayData('Sat', 420),
  _DayData('Sun', 115), // today (in progress)
];

// Monthly: 4 weeks in minutes
const _monthlyData = [
  _DayData('Wk 1', 1420),
  _DayData('Wk 2', 1890),
  _DayData('Wk 3', 1545),
  _DayData('Wk 4', 1715),
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
  _AppUsage('Twitter/X',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/X_logo_2023_original.svg/300px-X_logo_2023_original.svg.png',
      18),
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

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _monthly = false;

  List<_DayData> get _data => _monthly ? _monthlyData : _weeklyData;

  int get _dailyAvg {
    final data = _monthly ? _monthlyData : _weeklyData;
    final total = data.fold(0, (s, d) => s + d.minutes);
    final days = _monthly ? 28 : 7;
    return total ~/ days;
  }

  int get _weekTotal =>
      _weeklyData.fold(0, (s, d) => s + d.minutes);

  int get _longestSession => 145; // mock

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

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
                    Text('Analytics',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text('Screen time at a glance',
                        style: TextStyle(color: subColor, fontSize: 13)),
                  ],
                ),
              ),
            ),

            // ── Weekly / Monthly toggle ──────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _PillToggle(
                  monthly: _monthly,
                  onChanged: (v) => setState(() => _monthly = v),
                ),
              ),
            ),

            // ── Bar chart ────────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x4, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: GlassCard(
                  padding: const EdgeInsets.fromLTRB(
                      Sp.x5, Sp.x5, Sp.x5, Sp.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _monthly ? 'Monthly overview' : 'Past 7 days',
                        style: TextStyle(
                          color: subColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: Sp.x4),
                      SizedBox(
                        height: 160,
                        child: _BarChart(
                          data: _data,
                          highlightLast: !_monthly,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Stat chips ───────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x4, Sp.x5, 0),
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
                                value: _fmt(_dailyAvg),
                                color: AppColors.primary)),
                        _VertDivider(),
                        Expanded(
                            child: _StatChip(
                                label: 'Week total',
                                value: _fmt(_weekTotal),
                                color: AppColors.tierNormal)),
                        _VertDivider(),
                        Expanded(
                            child: _StatChip(
                                label: 'Longest',
                                value: _fmt(_longestSession),
                                color: AppColors.tierLong)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Most used ────────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'MOST USED THIS WEEK',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, Sp.x12),
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
          ],
        ),
      ),
    );
  }
}

// ── Pill toggle ───────────────────────────────────────────────────────────────

class _PillToggle extends StatelessWidget {
  final bool monthly;
  final ValueChanged<bool> onChanged;

  const _PillToggle({required this.monthly, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.full),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDim : AppColors.lightSurfaceDim,
            borderRadius: BorderRadius.circular(Rr.full),
            border: Border.all(
                color: isDark
                    ? AppColors.glassStroke
                    : AppColors.lightGlassStroke,
                width: 0.5),
          ),
          child: Row(
            children: [
              _PillOption(
                  label: 'Weekly', selected: !monthly,
                  onTap: () => onChanged(false)),
              _PillOption(
                  label: 'Monthly', selected: monthly,
                  onTap: () => onChanged(true)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PillOption(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: double.infinity,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(Rr.full),
            border: selected
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 0.5)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.primary : Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color,
              fontSize: 13,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bar chart ─────────────────────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final List<_DayData> data;
  final bool highlightLast;

  const _BarChart({required this.data, required this.highlightLast});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      painter: _BarChartPainter(
        data: data,
        highlightLast: highlightLast,
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
  final bool highlightLast;
  final bool isDark;
  final Color primaryColor;
  final Color mutedColor;
  final Color labelColor;
  final Color gridColor;

  const _BarChartPainter({
    required this.data,
    required this.highlightLast,
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
        data.map((d) => d.minutes).reduce(math.max).toDouble();
    const labelH = 20.0;
    const barRadius = Radius.circular(6);
    final chartH = size.height - labelH;
    final barW = (size.width / data.length) * 0.55;
    final gap = (size.width / data.length) * 0.45;

    // Grid lines (3 horizontal)
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    for (var i = 1; i <= 3; i++) {
      final y = chartH * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Bars
    for (var i = 0; i < data.length; i++) {
      final isToday = highlightLast && i == data.length - 1;
      final frac = data[i].minutes / maxVal;
      final barH = (chartH - 4) * frac;
      final left = i * (size.width / data.length) + gap / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, chartH - barH, barW, barH),
        barRadius,
      );

      if (isToday) {
        // Gradient bar for today
        final shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.6),
          ],
        ).createShader(
            Rect.fromLTWH(left, chartH - barH, barW, barH));
        canvas.drawRRect(
            rect,
            Paint()
              ..shader = shader
              ..style = PaintingStyle.fill);

        // Glow
        canvas.drawRRect(
            rect,
            Paint()
              ..color = primaryColor.withValues(alpha: 0.18)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
      } else {
        canvas.drawRRect(rect, Paint()..color = mutedColor);
      }

      // Day label
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
      tp.paint(
          canvas,
          Offset(
              left + barW / 2 - tp.width / 2, chartH + 6));
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.data != data ||
      old.highlightLast != highlightLast ||
      old.isDark != isDark;
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
                // Progress bar
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
