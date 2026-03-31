import 'package:flutter/material.dart';
import '../../app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricOverride = false;
  bool _showAppNames = true;
  bool _dailyReminders = false;
  bool _strictMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(context),
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, Sp.x8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SectionLabel('BLOCKING'),
                  const SizedBox(height: Sp.x3),
                  _SettingsGroup(tiles: [
                    _SwitchTile(
                      icon: Icons.lock_clock_rounded,
                      iconColor: AppColors.blocked,
                      title: 'Strict Mode',
                      subtitle:
                          'Disable all unlock options — no purchases or challenges',
                      value: _strictMode,
                      onChanged: (v) =>
                          setState(() => _strictMode = v),
                    ),
                    _SwitchTile(
                      icon: Icons.fingerprint_rounded,
                      iconColor: AppColors.primary,
                      title: 'Biometric Override',
                      subtitle:
                          'Allow Face ID or Touch ID to bypass a block',
                      value: _biometricOverride,
                      onChanged: (v) =>
                          setState(() => _biometricOverride = v),
                    ),
                    _SwitchTile(
                      icon: Icons.visibility_outlined,
                      iconColor: AppColors.info,
                      title: 'Show App Name on Lock Screen',
                      subtitle:
                          'Display which app is blocked when locked',
                      value: _showAppNames,
                      onChanged: (v) =>
                          setState(() => _showAppNames = v),
                    ),
                  ]),
                  const SizedBox(height: Sp.x6),
                  _SectionLabel('NOTIFICATIONS'),
                  const SizedBox(height: Sp.x3),
                  _SettingsGroup(tiles: [
                    _SwitchTile(
                      icon: Icons.notifications_outlined,
                      iconColor: AppColors.warning,
                      title: 'Daily Summary',
                      subtitle:
                          'Get a summary of screen time saved each evening',
                      value: _dailyReminders,
                      onChanged: (v) =>
                          setState(() => _dailyReminders = v),
                    ),
                  ]),
                  const SizedBox(height: Sp.x6),
                  _SectionLabel('PURCHASES'),
                  const SizedBox(height: Sp.x3),
                  _SettingsGroup(tiles: [
                    _NavTile(
                      icon: Icons.receipt_long_outlined,
                      iconColor: AppColors.unlocked,
                      title: 'Restore Purchases',
                      subtitle:
                          'Re-grant unlocks from a previous device or install',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: Sp.x6),
                  _SectionLabel('ABOUT'),
                  const SizedBox(height: Sp.x3),
                  _SettingsGroup(tiles: [
                    _NavTile(
                      icon: Icons.shield_outlined,
                      iconColor: AppColors.textMuted,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _NavTile(
                      icon: Icons.description_outlined,
                      iconColor: AppColors.textMuted,
                      title: 'Terms of Service',
                      onTap: () {},
                    ),
                    _InfoTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.textMuted,
                      title: 'Version',
                      value: '1.0.0',
                    ),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    )),
            const Text('Manage how AppGate works for you',
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

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

// ── Settings group card ───────────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  final List<Widget> tiles;
  const _SettingsGroup({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Rr.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(tiles.length, (i) {
          return Column(
            children: [
              tiles[i],
              if (i < tiles.length - 1)
                const Divider(
                  height: 1,
                  indent: Sp.x5 + 36 + Sp.x4,
                  color: AppColors.border,
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Tile variants ─────────────────────────────────────────────────────────────

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

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Sp.x5, vertical: Sp.x3),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          height: 1.4)),
                ],
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

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Rr.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Sp.x5, vertical: Sp.x3 + 2),
        child: Row(
          children: [
            _IconChip(icon: icon, color: iconColor),
            const SizedBox(width: Sp.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Sp.x5, vertical: Sp.x3 + 2),
      child: Row(
        children: [
          _IconChip(icon: icon, color: iconColor),
          const SizedBox(width: Sp.x4),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
          ),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 14)),
        ],
      ),
    );
  }
}
