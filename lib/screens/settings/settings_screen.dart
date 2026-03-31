import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settings',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text('App preferences',
                        style: TextStyle(color: subColor, fontSize: 13)),
                  ],
                ),
              ),
            ),

            // Appearance
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _Section(
                  label: 'APPEARANCE',
                  children: [
                    ValueListenableBuilder<ThemeMode>(
                      valueListenable: ThemeController.notifier,
                      builder: (_, mode, __) => _SwitchRow(
                        icon: mode == ThemeMode.dark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        iconColor: mode == ThemeMode.dark
                            ? AppColors.primary
                            : AppColors.warning,
                        title: 'Dark Mode',
                        subtitle: mode == ThemeMode.dark
                            ? 'OLED dark with glass cards'
                            : 'Light with frosted cards',
                        value: mode == ThemeMode.dark,
                        onChanged: (v) {
                          ThemeController.notifier.value =
                              v ? ThemeMode.dark : ThemeMode.light;
                        },
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Notifications
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _Section(
                  label: 'NOTIFICATIONS',
                  children: [
                    _SwitchRow(
                      icon: Icons.notifications_outlined,
                      iconColor: AppColors.warning,
                      title: 'Unlock Reminders',
                      subtitle: "Alert when you've used today's unlock",
                      value: _notifications,
                      onChanged: (v) => setState(() => _notifications = v),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            // Permissions
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _Section(
                  label: 'PERMISSIONS',
                  children: [
                    _NavRow(
                      icon: Icons.phonelink_lock_rounded,
                      iconColor: AppColors.tierShort,
                      title: 'Screen Time Access',
                      subtitle: 'Grant permission to read usage data',
                      onTap: () => _showPermissionSheet(context, isDark),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            // Legal
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Sp.x5, Sp.x5, Sp.x5, 0),
              sliver: SliverToBoxAdapter(
                child: _Section(
                  label: 'LEGAL',
                  children: [
                    _NavRow(
                      icon: Icons.shield_outlined,
                      iconColor: mutedColor,
                      title: 'Privacy Policy',
                      onTap: () {},
                      isDark: isDark,
                    ),
                    _Divider(isDark: isDark),
                    _NavRow(
                      icon: Icons.description_outlined,
                      iconColor: mutedColor,
                      title: 'Terms of Service',
                      onTap: () {},
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            // Version
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(Sp.x5, Sp.x6, Sp.x5, Sp.x12),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Text('AppGate 1.0.0',
                      style: TextStyle(color: mutedColor, fontSize: 13)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PermissionSheet(isDark: isDark),
    );
  }
}

// ── Section ───────────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const _Section({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: mutedColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0)),
        const SizedBox(height: Sp.x3),
        ClipRRect(
          borderRadius: BorderRadius.circular(Rr.xl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDim
                    : AppColors.lightSurfaceDim,
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
              child: Column(children: children),
            ),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) => Divider(
        height: 0.5,
        indent: Sp.x5 + 36 + Sp.x4,
        color: isDark ? AppColors.glassStroke : AppColors.lightGlassStroke,
      );
}

// ── Row variants ──────────────────────────────────────────────────────────────

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
  final bool isDark;

  const _SwitchRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.x5, vertical: Sp.x3),
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
                    style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        color: mutedColor, fontSize: 12, height: 1.3)),
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
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDark;

  const _NavRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
            _IconChip(icon: icon, color: iconColor),
            const SizedBox(width: Sp.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style:
                            TextStyle(color: mutedColor, fontSize: 12)),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: mutedColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Permission sheet ──────────────────────────────────────────────────────────

class _PermissionSheet extends StatelessWidget {
  final bool isDark;
  const _PermissionSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final subColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(Rr.xxl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0x1AFFFFFF) : const Color(0xCCFFFFFF),
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
              Text('Screen Time Access',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: Sp.x3),
              Text(
                'AppGate needs Screen Time permission to read your app usage data and display accurate analytics.\n\nOn iOS, go to Settings → Screen Time → AppGate.\nOn Android, go to Settings → Digital Wellbeing.',
                style: TextStyle(
                    color: subColor, fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: Sp.x6),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got It'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
