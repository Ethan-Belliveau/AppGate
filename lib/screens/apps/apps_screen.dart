import 'package:flutter/material.dart';
import '../../app_theme.dart';

class _AppData {
  final String name;
  final String category;
  final IconData icon;
  final Color iconColor;
  bool isBlocked;
  int? timeLimitMinutes;

  _AppData({
    required this.name,
    required this.category,
    required this.icon,
    required this.iconColor,
    this.isBlocked = false,
    this.timeLimitMinutes,
  });
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
      iconColor: const Color(0xFFE1306C),
      isBlocked: true,
      timeLimitMinutes: 30,
    ),
    _AppData(
      name: 'TikTok',
      category: 'Social',
      icon: Icons.music_note_rounded,
      iconColor: const Color(0xFF010101),
      isBlocked: true,
      timeLimitMinutes: 15,
    ),
    _AppData(
      name: 'YouTube',
      category: 'Entertainment',
      icon: Icons.play_circle_outline_rounded,
      iconColor: const Color(0xFFFF0000),
      isBlocked: false,
      timeLimitMinutes: 60,
    ),
    _AppData(
      name: 'Reddit',
      category: 'Social',
      icon: Icons.forum_outlined,
      iconColor: const Color(0xFFFF4500),
      isBlocked: true,
    ),
    _AppData(
      name: 'X (Twitter)',
      category: 'Social',
      icon: Icons.tag_rounded,
      iconColor: const Color(0xFF1DA1F2),
      isBlocked: false,
    ),
    _AppData(
      name: 'Snapchat',
      category: 'Social',
      icon: Icons.camera_alt_outlined,
      iconColor: const Color(0xFFFFFC00),
      isBlocked: false,
    ),
  ];

  int get _blockedCount => _apps.where((a) => a.isBlocked).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(context),
            if (_apps.isEmpty)
              SliverFillRemaining(child: _EmptyState())
            else ...[
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
                sliver: SliverToBoxAdapter(child: _SummaryBanner(
                  total: _apps.length,
                  blocked: _blockedCount,
                )),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
                sliver: SliverToBoxAdapter(
                  child: const Text(
                    'TAP TO EDIT TIME LIMITS · TOGGLE TO BLOCK',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(Sp.x5, Sp.x3, Sp.x5, Sp.x8),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(Rr.lg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: List.generate(_apps.length, (i) {
                        return Column(
                          children: [
                            _AppRow(
                              app: _apps[i],
                              onToggle: (v) =>
                                  setState(() => _apps[i].isBlocked = v),
                              onEdit: () =>
                                  _showTimeLimitSheet(context, _apps[i]),
                            ),
                            if (i < _apps.length - 1)
                              const Divider(
                                height: 1,
                                indent: Sp.x5 + 40 + Sp.x4,
                                color: AppColors.border,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apps',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              )),
                  Text('${_apps.length} apps · $_blockedCount blocked',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
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
                    horizontal: Sp.x4, vertical: 0),
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

  void _showTimeLimitSheet(BuildContext context, _AppData app) {
    int limit = app.timeLimitMinutes ?? 30;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Rr.xl)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(Sp.x6, Sp.x6, Sp.x6, Sp.x10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('Time Limit — ${app.name}',
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  if (app.timeLimitMinutes != null)
                    TextButton(
                      onPressed: () {
                        setState(() => app.timeLimitMinutes = null);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Remove',
                          style: TextStyle(color: AppColors.blocked)),
                    ),
                ],
              ),
              const SizedBox(height: Sp.x2),
              const Text(
                'App will be blocked once this daily limit is reached.',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: Sp.x6),
              Center(
                child: Text(
                  limit < 60
                      ? '$limit min/day'
                      : '${(limit / 60).toStringAsFixed(limit % 60 == 0 ? 0 : 1)} hr/day',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Slider(
                value: limit.toDouble(),
                min: 5,
                max: 240,
                divisions: 47,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.surfaceVariant,
                onChanged: (v) => setSheet(() => limit = v.round()),
              ),
              const SizedBox(height: Sp.x4),
              FilledButton(
                onPressed: () {
                  setState(() => app.timeLimitMinutes = limit);
                  Navigator.pop(ctx);
                },
                child: const Text('Set Limit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAppSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Rr.xl)),
      ),
      builder: (_) => Padding(
        padding:
            const EdgeInsets.fromLTRB(Sp.x6, Sp.x6, Sp.x6, Sp.x10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Add App',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: Sp.x2),
            const Text(
              'On iPhone, AppGate will read your installed apps via Screen Time API. '
              'Below is a preview of how this will work.',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5),
            ),
            const SizedBox(height: Sp.x6),
            Container(
              padding: const EdgeInsets.all(Sp.x4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Rr.md),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.phone_iphone_rounded,
                      color: AppColors.primary, size: 20),
                  SizedBox(width: Sp.x3),
                  Expanded(
                    child: Text(
                      'Full app picker requires running on an iPhone with Screen Time enabled.',
                      style: TextStyle(
                          color: AppColors.primary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App row ───────────────────────────────────────────────────────────────────

class _AppRow extends StatelessWidget {
  final _AppData app;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;

  const _AppRow({
    required this.app,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Sp.x5, vertical: Sp.x3 + 2),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: app.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rr.sm + 2),
              ),
              child: Icon(app.icon, color: app.iconColor, size: 20),
            ),
            const SizedBox(width: Sp.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(app.category,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted)),
                      if (app.timeLimitMinutes != null) ...[
                        const Text(' · ',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 12)),
                        Text(
                          app.timeLimitMinutes! < 60
                              ? '${app.timeLimitMinutes}m/day'
                              : '${app.timeLimitMinutes! ~/ 60}h/day',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.warning,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: app.isBlocked,
              onChanged: onToggle,
            ),
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
      return Container(
        padding: const EdgeInsets.all(Sp.x4),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(Rr.md),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          children: [
            Icon(Icons.toggle_off_rounded,
                color: AppColors.textMuted, size: 20),
            SizedBox(width: Sp.x3),
            Text(
              'No apps blocked. Toggle an app to start blocking it.',
              style:
                  TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(Sp.x4),
      decoration: BoxDecoration(
        color: AppColors.blocked.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Rr.md),
        border: Border.all(
            color: AppColors.blocked.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_rounded,
              color: AppColors.blocked, size: 18),
          const SizedBox(width: Sp.x3),
          Text(
            '$blocked of $total ${blocked == 1 ? 'app is' : 'apps are'} currently blocked.',
            style: const TextStyle(
                color: AppColors.blocked,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
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
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.apps_rounded,
                  color: AppColors.textMuted, size: 32),
            ),
            const SizedBox(height: Sp.x4),
            const Text('No apps added',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
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
