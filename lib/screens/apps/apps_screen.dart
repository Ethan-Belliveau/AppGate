import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/app_tier.dart';
import '../../models/blocked_app.dart';
import '../../state/blocked_apps_notifier.dart';
import '../../theme/tier_badge.dart';
import 'app_logo.dart';

// ── Catalogue ─────────────────────────────────────────────────────────────────

/// Fixed catalogue of apps users can add to the block list.
final _catalogue = [
  BlockedApp(name: 'Instagram', logoUrl: PopularAppLogos.instagram, tier: AppTier.normal, addedAt: DateTime(2000)),
  BlockedApp(name: 'TikTok', logoUrl: PopularAppLogos.tiktok, tier: AppTier.short, addedAt: DateTime(2000)),
  BlockedApp(name: 'YouTube', logoUrl: PopularAppLogos.youtube, tier: AppTier.long, addedAt: DateTime(2000)),
  BlockedApp(name: 'Twitter/X', logoUrl: PopularAppLogos.twitter, tier: AppTier.short, addedAt: DateTime(2000)),
  BlockedApp(name: 'Snapchat', logoUrl: PopularAppLogos.snapchat, tier: AppTier.normal, addedAt: DateTime(2000)),
  BlockedApp(name: 'Reddit', logoUrl: PopularAppLogos.reddit, tier: AppTier.normal, addedAt: DateTime(2000)),
  BlockedApp(name: 'Facebook', logoUrl: PopularAppLogos.facebook, tier: AppTier.normal, addedAt: DateTime(2000)),
  BlockedApp(name: 'Netflix', logoUrl: PopularAppLogos.netflix, tier: AppTier.long, addedAt: DateTime(2000)),
  BlockedApp(name: 'WhatsApp', logoUrl: PopularAppLogos.whatsapp, tier: AppTier.short, addedAt: DateTime(2000)),
  BlockedApp(name: 'LinkedIn', logoUrl: PopularAppLogos.linkedin, tier: AppTier.short, addedAt: DateTime(2000)),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ValueListenableBuilder<List<BlockedApp>>(
          valueListenable: BlockedAppsNotifier.notifier,
          builder: (_, apps, __) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Apps',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge),
                              Text(
                                '${apps.length} app${apps.length != 1 ? 's' : ''} blocked',
                                style: TextStyle(
                                    color: subColor, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () => _showAddSheet(context, apps),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Add App'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Sp.x4),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Rr.full)),
                            textStyle: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (apps.isEmpty)
                  const SliverFillRemaining(child: _EmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                        Sp.x5, Sp.x5, Sp.x5, Sp.x12),
                    sliver: SliverToBoxAdapter(
                      child: _AppList(
                        apps: apps,
                        onTap: (i) =>
                            _showAppSheet(context, i, apps[i]),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAppSheet(BuildContext context, int index, BlockedApp app) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AppDetailSheet(
        app: app,
        locked: app.is24hrLocked,
        onTierChanged: (t) => BlockedAppsNotifier.updateTier(index, t),
        onRemove: () {
          BlockedAppsNotifier.remove(index);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context, List<BlockedApp> current) {
    // Apps that can't be added: already blocked OR removed within last 24hrs.
    // We only track currently-blocked names here for simplicity.
    final blockedNames = current.map((a) => a.name).toSet();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AddAppSheet(
        alreadyBlocked: blockedNames,
        onAdd: (app) => BlockedAppsNotifier.add(app),
      ),
    );
  }
}

// ── App list card ─────────────────────────────────────────────────────────────

class _AppList extends StatelessWidget {
  final List<BlockedApp> apps;
  final void Function(int) onTap;

  const _AppList({required this.apps, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDim : AppColors.lightSurfaceDim,
            borderRadius: BorderRadius.circular(Rr.xl),
            border: Border.all(
                color: isDark
                    ? AppColors.glassStroke
                    : AppColors.lightGlassStroke,
                width: 0.5),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                        color: const Color(0x0F000000),
                        blurRadius: 20,
                        offset: const Offset(0, 4))
                  ],
          ),
          child: Column(
            children: List.generate(apps.length, (i) {
              return Column(
                children: [
                  _AppRow(app: apps[i], onTap: () => onTap(i)),
                  if (i < apps.length - 1)
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
    );
  }
}

class _AppRow extends StatelessWidget {
  final BlockedApp app;
  final VoidCallback onTap;

  const _AppRow({required this.app, required this.onTap});

  String _lockLabel() {
    final r = app.lockRemaining;
    final h = r.inHours;
    final m = r.inMinutes % 60;
    if (h > 0 && m > 0) return 'Locked ${h}h ${m}m';
    if (h > 0) return 'Locked ${h}h';
    return 'Locked ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Rr.xl),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Sp.x5, vertical: Sp.x3 + 2),
        child: Row(
          children: [
            AppLogo(
                url: app.logoUrl,
                name: app.name,
                size: 44,
                borderRadius: 10),
            const SizedBox(width: Sp.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.name,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  TierBadge(tier: app.tier, compact: true),
                ],
              ),
            ),
            // 24hr lock indicator
            if (app.is24hrLocked) ...[
              Icon(Icons.lock_rounded, color: mutedColor, size: 14),
              const SizedBox(width: 4),
              Text(_lockLabel(),
                  style: TextStyle(color: mutedColor, fontSize: 11)),
              const SizedBox(width: Sp.x2),
            ],
            Icon(Icons.chevron_right_rounded,
                color: mutedColor, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── App detail sheet ──────────────────────────────────────────────────────────

class _AppDetailSheet extends StatefulWidget {
  final BlockedApp app;
  final bool locked;
  final ValueChanged<AppTier> onTierChanged;
  final VoidCallback onRemove;

  const _AppDetailSheet({
    required this.app,
    required this.locked,
    required this.onTierChanged,
    required this.onRemove,
  });

  @override
  State<_AppDetailSheet> createState() => _AppDetailSheetState();
}

class _AppDetailSheetState extends State<_AppDetailSheet> {
  late AppTier _tier;

  @override
  void initState() {
    super.initState();
    _tier = widget.app.tier;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0x1AFFFFFF)
                  : const Color(0xCCFFFFFF),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
              border: Border(
                  top: BorderSide(
                      color: isDark
                          ? AppColors.glassStroke
                          : AppColors.lightGlassStroke,
                      width: 0.5)),
            ),
            padding:
                const EdgeInsets.fromLTRB(Sp.x6, Sp.x5, Sp.x6, Sp.x10),
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
                      color: isDark
                          ? AppColors.glassStroke
                          : AppColors.lightGlassStroke,
                      borderRadius: BorderRadius.circular(Rr.full),
                    ),
                  ),
                ),
                const SizedBox(height: Sp.x5),
                // App header
                Row(
                  children: [
                    AppLogo(
                        url: widget.app.logoUrl,
                        name: widget.app.name,
                        size: 52,
                        borderRadius: 12),
                    const SizedBox(width: Sp.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.app.name,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          if (widget.locked) ...[
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.lock_rounded,
                                    size: 12, color: mutedColor),
                                const SizedBox(width: 4),
                                Text('Locked for 24h from add',
                                    style: TextStyle(
                                        color: mutedColor, fontSize: 12)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sp.x6),
                // Tier section
                Text('TIER',
                    style: TextStyle(
                        color: mutedColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0)),
                const SizedBox(height: Sp.x3),
                // Tier selector (disabled during lock)
                Row(
                  children: AppTier.values.map((t) {
                    final sel = t == _tier;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: GestureDetector(
                          onTap: widget.locked
                              ? null
                              : () {
                                  setState(() => _tier = t);
                                  widget.onTierChanged(t);
                                },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                vertical: Sp.x3),
                            decoration: BoxDecoration(
                              color: sel
                                  ? t.color.withValues(alpha: 0.14)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(Rr.md),
                              border: Border.all(
                                color: sel
                                    ? t.color.withValues(alpha: 0.50)
                                    : (isDark
                                        ? AppColors.glassStroke
                                        : AppColors.lightGlassStroke),
                                width: sel ? 1.0 : 0.5,
                              ),
                            ),
                            child: Opacity(
                              opacity: widget.locked ? 0.45 : 1.0,
                              child: Column(
                                children: [
                                  Text(t.label,
                                      style: TextStyle(
                                          color: sel ? t.color : subColor,
                                          fontSize: 13,
                                          fontWeight:
                                              FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(t.unlockPrice,
                                      style: TextStyle(
                                          color: sel
                                              ? t.color
                                                  .withValues(alpha: 0.7)
                                              : mutedColor,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: Sp.x3),
                // Tier info
                Container(
                  padding: const EdgeInsets.all(Sp.x4),
                  decoration: BoxDecoration(
                    color: _tier.color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(Rr.md),
                    border: Border.all(
                        color: _tier.color.withValues(alpha: 0.2),
                        width: 0.5),
                  ),
                  child: Text(
                    '${_tier.label} tier · unlock for ${_tier.unlockPrice}/day · task ${_tier.taskDuration}',
                    style: TextStyle(
                        color: _tier.color, fontSize: 12, height: 1.4),
                  ),
                ),
                if (widget.locked) ...[
                  const SizedBox(height: Sp.x3),
                  Container(
                    padding: const EdgeInsets.all(Sp.x3),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(Rr.md),
                      border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock_clock_rounded,
                            size: 14, color: AppColors.warning),
                        const SizedBox(width: Sp.x2),
                        Text(
                          'Tier and removal locked for 24 hours.',
                          style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: Sp.x6),
                // Remove button (disabled during lock)
                OutlinedButton(
                  onPressed: widget.locked ? null : widget.onRemove,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blocked,
                    disabledForegroundColor:
                        AppColors.blocked.withValues(alpha: 0.35),
                    side: BorderSide(
                        color: widget.locked
                            ? AppColors.blocked.withValues(alpha: 0.2)
                            : AppColors.blocked.withValues(alpha: 0.4)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Remove from Block List'),
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

class _AddAppSheet extends StatefulWidget {
  final Set<String> alreadyBlocked;
  final void Function(BlockedApp) onAdd;

  const _AddAppSheet(
      {required this.alreadyBlocked, required this.onAdd});

  @override
  State<_AddAppSheet> createState() => _AddAppSheetState();
}

class _AddAppSheetState extends State<_AddAppSheet> {
  final Map<String, AppTier> _selectedTiers = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    final available = _catalogue
        .where((a) => !widget.alreadyBlocked.contains(a.name))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0x1AFFFFFF)
                  : const Color(0xCCFFFFFF),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Rr.xxl)),
              border: Border(
                  top: BorderSide(
                      color: isDark
                          ? AppColors.glassStroke
                          : AppColors.lightGlassStroke,
                      width: 0.5)),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(Sp.x6, Sp.x5, Sp.x6, 0),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.glassStroke
                                : AppColors.lightGlassStroke,
                            borderRadius: BorderRadius.circular(Rr.full),
                          ),
                        ),
                      ),
                      const SizedBox(height: Sp.x4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Add App',
                            style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: Sp.x1),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Choose a tier, then tap + to block.',
                            style: TextStyle(
                                color: mutedColor, fontSize: 13)),
                      ),
                      const SizedBox(height: Sp.x4),
                    ],
                  ),
                ),
                Divider(
                    height: 0.5,
                    color: isDark
                        ? AppColors.glassStroke
                        : AppColors.lightGlassStroke),
                Expanded(
                  child: available.isEmpty
                      ? Center(
                          child: Text(
                              'All popular apps are already blocked!',
                              style: TextStyle(
                                  color: mutedColor, fontSize: 14)),
                        )
                      : ListView.separated(
                          controller: controller,
                          padding: const EdgeInsets.fromLTRB(
                              Sp.x5, Sp.x3, Sp.x5, Sp.x10),
                          itemCount: available.length,
                          separatorBuilder: (_, __) => Divider(
                              height: 0.5,
                              indent: Sp.x5 + 44 + Sp.x4,
                              color: isDark
                                  ? AppColors.glassStroke
                                  : AppColors.lightGlassStroke),
                          itemBuilder: (_, i) {
                            final app = available[i];
                            final tier =
                                _selectedTiers[app.name] ?? app.tier;
                            return _CatalogueRow(
                              app: app,
                              tier: tier,
                              isDark: isDark,
                              textColor: textColor,
                              mutedColor: mutedColor,
                              onTierChanged: (t) => setState(
                                  () => _selectedTiers[app.name] = t),
                              onAdd: () {
                                widget.onAdd(BlockedApp(
                                  name: app.name,
                                  logoUrl: app.logoUrl,
                                  tier: tier,
                                  // addedAt defaults to now → 24hr lock
                                ));
                                Navigator.pop(context);
                              },
                            );
                          },
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

class _CatalogueRow extends StatelessWidget {
  final BlockedApp app;
  final AppTier tier;
  final bool isDark;
  final Color textColor;
  final Color mutedColor;
  final ValueChanged<AppTier> onTierChanged;
  final VoidCallback onAdd;

  const _CatalogueRow({
    required this.app,
    required this.tier,
    required this.isDark,
    required this.textColor,
    required this.mutedColor,
    required this.onTierChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sp.x3),
      child: Row(
        children: [
          AppLogo(
              url: app.logoUrl,
              name: app.name,
              size: 44,
              borderRadius: 10),
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
                const SizedBox(height: 4),
                Row(
                  children: AppTier.values.map((t) {
                    final sel = t == tier;
                    return Padding(
                      padding: const EdgeInsets.only(right: Sp.x2),
                      child: GestureDetector(
                        onTap: () => onTierChanged(t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Sp.x2 + 1, vertical: 2),
                          decoration: BoxDecoration(
                            color: sel
                                ? t.color.withValues(alpha: 0.14)
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(Rr.full),
                            border: Border.all(
                              color: sel
                                  ? t.color.withValues(alpha: 0.45)
                                  : (isDark
                                      ? AppColors.glassStroke
                                      : AppColors.lightGlassStroke),
                              width: 0.5,
                            ),
                          ),
                          child: Text(t.label,
                              style: TextStyle(
                                  color: sel ? t.color : mutedColor,
                                  fontSize: 11,
                                  fontWeight: sel
                                      ? FontWeight.w600
                                      : FontWeight.w400)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: Sp.x3),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 0.5),
              ),
              child: const Icon(Icons.add_rounded,
                  color: AppColors.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

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
                color: isDark
                    ? AppColors.surfaceDim
                    : AppColors.lightSurfaceDim,
                shape: BoxShape.circle,
                border: Border.all(
                    color: isDark
                        ? AppColors.glassStroke
                        : AppColors.lightGlassStroke,
                    width: 0.5),
              ),
              child:
                  Icon(Icons.block_rounded, color: mutedColor, size: 32),
            ),
            const SizedBox(height: Sp.x5),
            Text('No apps blocked yet',
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: Sp.x2),
            Text(
              'Add one to get started.',
              style: TextStyle(color: subColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
