import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/subscription.dart';

class YouScreen extends StatefulWidget {
  const YouScreen({super.key});

  @override
  State<YouScreen> createState() => _YouScreenState();
}

class _YouScreenState extends State<YouScreen> {
  // Mock state
  final _sub = Subscription.free;
  bool _strictMode = false;
  bool _notifications = true;
  bool _faceId = false;

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
                child: _SubscriptionCard(sub: _sub),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(child: _StatsCard()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _SettingsSection(
                  strictMode: _strictMode,
                  notifications: _notifications,
                  faceId: _faceId,
                  onStrictMode: (v) => setState(() => _strictMode = v),
                  onNotifications: (v) => setState(() => _notifications = v),
                  onFaceId: (v) => setState(() => _faceId = v),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(child: _LinksSection()),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: Sp.x12),
              sliver: SliverToBoxAdapter(child: SizedBox()),
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
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35)),
              ),
              child: const Center(
                child: Text(
                  'E',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Sp.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You',
                    style:
                        Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        '🔥 5 day streak',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const Text(
                        '  ·  ',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      const Text(
                        'Since Jan 2025',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
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

// ── Subscription card ─────────────────────────────────────────────────────────

class _SubscriptionCard extends StatelessWidget {
  final Subscription sub;

  const _SubscriptionCard({required this.sub});

  @override
  Widget build(BuildContext context) {
    final isPro = sub.plan.isPro;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.xxl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(Sp.x5),
          decoration: BoxDecoration(
            color: isPro
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(Rr.xxl),
            border: Border.all(
              color: isPro
                  ? AppColors.primary.withValues(alpha: 0.40)
                  : AppColors.glassStroke,
              width: isPro ? 1.0 : 0.5,
            ),
            boxShadow: isPro
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 32,
                      spreadRadius: -4,
                    )
                  ]
                : null,
          ),
          child: isPro ? _proLayout(context) : _freeLayout(context),
        ),
      ),
    );
  }

  Widget _freeLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Sp.x3, vertical: Sp.x1 + 2),
              decoration: BoxDecoration(
                color: AppColors.glassStroke,
                borderRadius: BorderRadius.circular(Rr.full),
              ),
              child: const Text(
                'FREE',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Sp.x4),
        const Text(
          'Unlock the full AppGate',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: Sp.x2),
        const Text(
          'Pro adds pay-to-unlock, detailed stats, custom tasks, and Strict Mode.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: Sp.x5),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 46),
                ),
                child: const Text('Upgrade to Pro — \$4.99/mo'),
              ),
            ),
          ],
        ),
        const SizedBox(height: Sp.x3),
        Center(
          child: Text(
            '\$34.99/yr · Save 42%',
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _proLayout(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(Rr.md),
          ),
          child: const Icon(Icons.verified_rounded,
              color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: Sp.x4),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AppGate Pro',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Renews Apr 30, 2026',
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 36),
            padding:
                const EdgeInsets.symmetric(horizontal: Sp.x4),
            side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.4)),
          ),
          child: const Text('Manage',
              style: TextStyle(fontSize: 13, color: AppColors.primary)),
        ),
      ],
    );
  }
}

// ── Stats card ────────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Rr.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(Sp.x5),
          decoration: BoxDecoration(
            color: AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(Rr.xl),
            border: Border.all(color: AppColors.glassStroke, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR STATS',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: Sp.x4),
              Row(
                children: [
                  Expanded(
                    child: _StatCell(
                      value: '3h 12m',
                      label: 'Screen time\nsaved',
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                      width: 0.5, height: 48, color: AppColors.glassStroke),
                  Expanded(
                    child: _StatCell(
                      value: '8',
                      label: 'Tasks\ncompleted',
                      color: AppColors.unlocked,
                    ),
                  ),
                  Container(
                      width: 0.5, height: 48, color: AppColors.glassStroke),
                  Expanded(
                    child: _StatCell(
                      value: '3',
                      label: 'Unlocks\nused',
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCell(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ── Settings section ──────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final bool strictMode;
  final bool notifications;
  final bool faceId;
  final ValueChanged<bool> onStrictMode;
  final ValueChanged<bool> onNotifications;
  final ValueChanged<bool> onFaceId;

  const _SettingsSection({
    required this.strictMode,
    required this.notifications,
    required this.faceId,
    required this.onStrictMode,
    required this.onNotifications,
    required this.onFaceId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('SETTINGS'),
        const SizedBox(height: Sp.x3),
        _GlassGroup(
          children: [
            _SwitchRow(
              icon: Icons.lock_clock_rounded,
              iconColor: AppColors.blocked,
              title: 'Strict Mode',
              subtitle: 'Disable all unlock options',
              value: strictMode,
              onChanged: onStrictMode,
            ),
            _divider(),
            _SwitchRow(
              icon: Icons.notifications_outlined,
              iconColor: AppColors.warning,
              title: 'Notifications',
              subtitle: 'Daily summary each evening',
              value: notifications,
              onChanged: onNotifications,
            ),
            _divider(),
            _SwitchRow(
              icon: Icons.face_rounded,
              iconColor: AppColors.primary,
              title: 'Face ID Lock',
              subtitle: 'Require Face ID to change settings',
              value: faceId,
              onChanged: onFaceId,
            ),
          ],
        ),
      ],
    );
  }

  static Widget _divider() => const Divider(
      height: 0.5, indent: Sp.x5 + 36 + Sp.x4, color: AppColors.glassStroke);
}

// ── Links section ─────────────────────────────────────────────────────────────

class _LinksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('ABOUT'),
        const SizedBox(height: Sp.x3),
        _GlassGroup(
          children: [
            _NavRow(
              icon: Icons.shield_outlined,
              iconColor: AppColors.textMuted,
              title: 'Privacy Policy',
              onTap: () {},
            ),
            _divider(),
            _NavRow(
              icon: Icons.description_outlined,
              iconColor: AppColors.textMuted,
              title: 'Terms of Service',
              onTap: () {},
            ),
            _divider(),
            _NavRow(
              icon: Icons.support_agent_rounded,
              iconColor: AppColors.textMuted,
              title: 'Support',
              onTap: () {},
            ),
            _divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Sp.x5, vertical: Sp.x3 + 2),
              child: Row(
                children: [
                  _IconChip(
                      icon: Icons.info_outline_rounded,
                      color: AppColors.textMuted),
                  const SizedBox(width: Sp.x4),
                  const Expanded(
                    child: Text(
                      'Version',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Text(
                    '1.0.0',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _divider() => const Divider(
      height: 0.5, indent: Sp.x5 + 36 + Sp.x4, color: AppColors.glassStroke);
}

// ── Glass group wrapper ───────────────────────────────────────────────────────

class _GlassGroup extends StatelessWidget {
  final List<Widget> children;

  const _GlassGroup({required this.children});

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
          child: Column(children: children),
        ),
      ),
    );
  }
}

// ── Row widgets ───────────────────────────────────────────────────────────────

class _IconChip extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconChip({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Rr.sm),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Sp.x5, vertical: Sp.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconChip(icon: icon, color: iconColor),
          const SizedBox(width: Sp.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: Sp.x2),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.iconColor,
    required this.title,
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
            _IconChip(icon: icon, color: iconColor),
            const SizedBox(width: Sp.x4),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

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
