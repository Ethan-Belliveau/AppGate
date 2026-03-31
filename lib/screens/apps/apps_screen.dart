import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/app_tier.dart';
import '../../theme/tier_badge.dart';

class _AppData {
  final String name;
  final String category;
  final IconData icon;
  final Color iconColor;
  bool isBlocked;
  AppTier tier;
  int usedMinutes;

  _AppData({
    required this.name,
    required this.category,
    required this.icon,
    required this.iconColor,
    this.isBlocked = false,
    this.tier = AppTier.normal,
    this.usedMinutes = 0,
  });

  int get remainingMinutes =>
      (tier.allowanceMinutes - usedMinutes).clamp(0, tier.allowanceMinutes);
}

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final List<_AppData> _apps = [
    _AppData(
      name: 'Instagram',
      category: 'Social',
      icon: Icons.photo_camera_outlined,
      iconColor: Color(0xFFE1306C),
      isBlocked: true,
      tier: AppTier.normal,
      usedMinutes: 12,
    ),
    _AppData(
      name: 'TikTok',
      category: 'Social',
      icon: Icons.music_note_rounded,
      iconColor: Color(0xFF69C9D0),
      isBlocked: true,
      tier: AppTier.short,
      usedMinutes: 8,
    ),
    _AppData(
      name: 'YouTube',
      category: 'Entertainment',
      icon: Icons.play_circle_outline_rounded,
      iconColor: Color(0xFFFF0000),
      isBlocked: false,
      tier: AppTier.long,
      usedMinutes: 22,
    ),
    _AppData(
      name: 'Reddit',
      category: 'Social',
      icon: Icons.forum_outlined,
      iconColor: Color(0xFFFF4500),
      isBlocked: true,
      tier: AppTier.normal,
      usedMinutes: 0,
    ),
    _AppData(
      name: 'X',
      category: 'Social',
      icon: Icons.tag_rounded,
      iconColor: Color(0xFF1DA1F2),
      isBlocked: false,
      tier: AppTier.short,
    ),
    _AppData(
      name: 'Snapchat',
      category: 'Social',
      icon: Icons.camera_alt_outlined,
      iconColor: Color(0xFFFFFC00),
      isBlocked: false,
      tier: AppTier.normal,
    ),
  ];

  int get _blockedCount => _apps.where((a) => a.isBlocked).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(context),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _SummaryBanner(
                    total: _apps.length, blocked: _blockedCount),
              ),
            ),
            if (_apps.isEmpty)
              const SliverFillRemaining(child: _EmptyState())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    Sp.x5, Sp.x4, Sp.x5, Sp.x12),
                sliver: SliverToBoxAdapter(child: _AppList(
                  apps: _apps,
                  onToggle: (i, v) => setState(() => _apps[i].isBlocked = v),
                  onEdit: (i) => _showAppSheet(context, _apps[i], i),
                )),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apps',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  Text(
                    '${_apps.length} apps · $_blockedCount blocked',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _showAddAppSheet(context),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add App'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(
                    horizontal: Sp.x4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rr.full)),
                textStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppSheet(BuildContext context, _AppData app, int index) {
    AppTier selectedTier = app.tier;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AppDetailSheet(
        app: app,
        initialTier: selectedTier,
        onTierChanged: (t) => setState(() => app.tier = t),
        onToggle: (v) => setState(() => app.isBlocked = v),
      ),
    );
  }

  void _showAddAppSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAppSheet(),
    );
  }
}

// ── App list card ─────────────────────────────────────────────────────────────

class _AppList extends StatelessWidget {
  final List<_AppData> apps;
  final void Function(int, bool) onToggle;
  final void Function(int) onEdit;

  const _AppList({
    required this.apps,
    required this.onToggle,
    required this.onEdit,
  });

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
            children: List.generate(apps.length, (i) {
              return Column(
                children: [
                  _AppRow(
                    app: apps[i],
                    onToggle: (v) => onToggle(i, v),
                    onTap: () => onEdit(i),
                  ),
                  if (i < apps.length - 1)
                    const Divider(
                      height: 0.5,
                      indent: Sp.x5 + 44 + Sp.x4,
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
}

class _AppRow extends StatelessWidget {
  final _AppData app;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  const _AppRow({
    required this.app,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Rr.xl),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Sp.x5, vertical: Sp.x3 + 2),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: app.iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(Rr.md),
                border: Border.all(
                    color: app.iconColor.withValues(alpha: 0.25),
                    width: 0.5),
              ),
              child: Icon(app.icon, color: app.iconColor, size: 22),
            ),
            const SizedBox(width: Sp.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.name,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      TierBadge(tier: app.tier, compact: true),
                      const SizedBox(width: Sp.x2),
                      Text(
                        '${app.remainingMinutes}m left',
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: app.isBlocked,
              onChanged: onToggle,
            ),
            const SizedBox(width: Sp.x1),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Summary banner ────────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final int total;
  final int blocked;

  const _SummaryBanner({required this.total, required this.blocked});

  @override
  Widget build(BuildContext context) {
    if (blocked == 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Rr.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(Sp.x4),
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: BorderRadius.circular(Rr.lg),
              border: Border.all(color: AppColors.glassStroke, width: 0.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.toggle_off_rounded,
                    color: AppColors.textMuted, size: 20),
                SizedBox(width: Sp.x3),
                Expanded(
                  child: Text(
                    'No apps blocked. Toggle an app to start blocking.',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(Sp.x4),
          decoration: BoxDecoration(
            color: AppColors.blocked.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(Rr.lg),
            border: Border.all(
                color: AppColors.blocked.withValues(alpha: 0.25),
                width: 0.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_rounded,
                  color: AppColors.blocked, size: 18),
              const SizedBox(width: Sp.x3),
              Text(
                '$blocked of $total ${blocked == 1 ? 'app is' : 'apps are'} currently blocked',
                style: const TextStyle(
                    color: AppColors.blocked,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── App detail bottom sheet ───────────────────────────────────────────────────

class _AppDetailSheet extends StatefulWidget {
  final _AppData app;
  final AppTier initialTier;
  final ValueChanged<AppTier> onTierChanged;
  final ValueChanged<bool> onToggle;

  const _AppDetailSheet({
    required this.app,
    required this.initialTier,
    required this.onTierChanged,
    required this.onToggle,
  });

  @override
  State<_AppDetailSheet> createState() => _AppDetailSheetState();
}

class _AppDetailSheetState extends State<_AppDetailSheet> {
  late AppTier _tier;
  late bool _blocked;

  @override
  void initState() {
    super.initState();
    _tier = widget.initialTier;
    _blocked = widget.app.isBlocked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Rr.xxl)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0x1AFFFFFF),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
              border: Border(
                top: BorderSide(color: AppColors.glassStroke, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
                Sp.x6, Sp.x5, Sp.x6, Sp.x10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.glassStroke,
                      borderRadius: BorderRadius.circular(Rr.full),
                    ),
                  ),
                ),
                const SizedBox(height: Sp.x5),
                // App header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.app.iconColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(Rr.md),
                        border: Border.all(
                            color: widget.app.iconColor
                                .withValues(alpha: 0.25),
                            width: 0.5),
                      ),
                      child: Icon(widget.app.icon,
                          color: widget.app.iconColor, size: 24),
                    ),
                    const SizedBox(width: Sp.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.app.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.app.category,
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _blocked,
                      onChanged: (v) {
                        setState(() => _blocked = v);
                        widget.onToggle(v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: Sp.x6),
                // Tier selector
                const Text(
                  'TIER',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: Sp.x3),
                Row(
                  children: AppTier.values.map((t) {
                    final selected = t == _tier;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _tier = t);
                            widget.onTierChanged(t);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                vertical: Sp.x3),
                            decoration: BoxDecoration(
                              color: selected
                                  ? t.color.withValues(alpha: 0.15)
                                  : AppColors.surfaceDim,
                              borderRadius:
                                  BorderRadius.circular(Rr.md),
                              border: Border.all(
                                color: selected
                                    ? t.color.withValues(alpha: 0.50)
                                    : AppColors.glassStroke,
                                width: selected ? 1.0 : 0.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  t.label,
                                  style: TextStyle(
                                    color: selected
                                        ? t.color
                                        : AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  t.allowanceLabel,
                                  style: TextStyle(
                                    color: selected
                                        ? t.color.withValues(alpha: 0.7)
                                        : AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: Sp.x4),
                // Tier description
                Container(
                  padding: const EdgeInsets.all(Sp.x4),
                  decoration: BoxDecoration(
                    color: _tier.color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(Rr.md),
                    border: Border.all(
                        color: _tier.color.withValues(alpha: 0.2),
                        width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: _tier.color, size: 16),
                      const SizedBox(width: Sp.x3),
                      Expanded(
                        child: Text(
                          '${_tier.label} tier: ${_tier.allowanceMinutes}m/day allowance · unlock with ${_tier.taskDuration} task · ${_tier.unlockPrice} (Pro)',
                          style: TextStyle(
                              color: _tier.color, fontSize: 12, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Add App sheet ─────────────────────────────────────────────────────────────

class _AddAppSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x1AFFFFFF),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
            border: Border(
              top: BorderSide(color: AppColors.glassStroke, width: 0.5),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
              Sp.x6, Sp.x5, Sp.x6, Sp.x10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.glassStroke,
                    borderRadius: BorderRadius.circular(Rr.full),
                  ),
                ),
              ),
              const SizedBox(height: Sp.x5),
              const Text(
                'Add App',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Sp.x2),
              const Text(
                'On device, AppGate reads your installed apps via Screen Time API. Each app is assigned a tier that controls its daily allowance and unlock cost.',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5),
              ),
              const SizedBox(height: Sp.x5),
              // Tier explainer
              ...AppTier.values.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: Sp.x3),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: t.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: Sp.x3),
                        Text(
                          '${t.label}  ',
                          style: TextStyle(
                            color: t.color,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${t.allowanceLabel} · task ${t.taskDuration} · ${t.unlockPrice} Pro',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: Sp.x3),
              Container(
                padding: const EdgeInsets.all(Sp.x4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Rr.md),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 0.5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.phone_iphone_rounded,
                        color: AppColors.primary, size: 18),
                    SizedBox(width: Sp.x3),
                    Expanded(
                      child: Text(
                        'Full app picker requires running on iOS with Screen Time enabled.',
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 12),
                      ),
                    ),
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

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
                color: AppColors.surfaceDim,
                shape: BoxShape.circle,
                border:
                    Border.all(color: AppColors.glassStroke, width: 0.5),
              ),
              child: const Icon(Icons.apps_rounded,
                  color: AppColors.textMuted, size: 32),
            ),
            const SizedBox(height: Sp.x5),
            const Text(
              'No apps added',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: Sp.x2),
            const Text(
              'Tap "Add App" to choose which apps\nAppGate should monitor and block.',
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
