import 'package:flutter/material.dart';
import '../../app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _allowBiometricOverride = false;
  bool _showBlockedAppNames = true;
  bool _dailyReminders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(child: _SettingsHeader()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SectionLabel('BLOCKING'),
                  const SizedBox(height: 8),
                  _SettingsCard(children: [
                    _SwitchTile(
                      icon: Icons.fingerprint_rounded,
                      iconColor: AppColors.primary,
                      title: 'Biometric Override',
                      subtitle: 'Allow Face ID / Touch ID to bypass block',
                      value: _allowBiometricOverride,
                      onChanged: (v) =>
                          setState(() => _allowBiometricOverride = v),
                    ),
                    _Divider(),
                    _SwitchTile(
                      icon: Icons.visibility_rounded,
                      iconColor: AppColors.info,
                      title: 'Show App Names',
                      subtitle: 'Display app name on the lock screen',
                      value: _showBlockedAppNames,
                      onChanged: (v) =>
                          setState(() => _showBlockedAppNames = v),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _SectionLabel('NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  _SettingsCard(children: [
                    _SwitchTile(
                      icon: Icons.notifications_outlined,
                      iconColor: AppColors.warning,
                      title: 'Daily Reminders',
                      subtitle: 'Get a nudge to review your screen time',
                      value: _dailyReminders,
                      onChanged: (v) =>
                          setState(() => _dailyReminders = v),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _SectionLabel('PURCHASES'),
                  const SizedBox(height: 8),
                  _SettingsCard(children: [
                    _NavTile(
                      icon: Icons.receipt_long_rounded,
                      iconColor: AppColors.unlocked,
                      title: 'Restore Purchases',
                      subtitle: 'Recover previous one-time unlocks',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _SectionLabel('ABOUT'),
                  const SizedBox(height: 8),
                  _SettingsCard(children: [
                    _NavTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.textMuted,
                      title: 'Version',
                      subtitle: '1.0.0 (build 1)',
                      onTap: null,
                    ),
                    _Divider(),
                    _NavTile(
                      icon: Icons.shield_outlined,
                      iconColor: AppColors.textMuted,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _Divider(),
                    _NavTile(
                      icon: Icons.description_outlined,
                      iconColor: AppColors.textMuted,
                      title: 'Terms of Service',
                      onTap: () {},
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
}

// ── Header ──────────────────────────────────────────────────────────────────

class _SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textSecondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

// ── Reusable sub-widgets ────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 0,
      color: AppColors.border,
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
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: onTap != null
          ? const Icon(Icons.chevron_right_rounded,
              color: AppColors.textMuted, size: 20)
          : null,
    );
  }
}
