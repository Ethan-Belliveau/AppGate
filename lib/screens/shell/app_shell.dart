import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../analytics/analytics_screen.dart';
import '../apps/apps_screen.dart';
import '../challenges/challenges_screen.dart';
import '../settings/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard_rounded),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.flag_outlined),
      selectedIcon: Icon(Icons.flag_rounded),
      label: 'Challenges',
    ),
    NavigationDestination(
      icon: Icon(Icons.block_outlined),
      selectedIcon: Icon(Icons.block_rounded),
      label: 'Apps',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings_rounded),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.background : AppColors.lightBackground,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(decoration: AppBg.of(context)),
          ),
          IndexedStack(
            index: _index,
            children: const [
              AnalyticsScreen(),
              ChallengesScreen(),
              AppsScreen(),
              SettingsScreen(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _GlassNavBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _destinations,
        isDark: isDark,
      ),
    );
  }
}

class _GlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final bool isDark;

  const _GlassNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0x0DFFFFFF)
                : const Color(0x99FFFFFF),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? AppColors.glassStroke
                    : AppColors.lightGlassStroke,
                width: 0.5,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations,
          ),
        ),
      ),
    );
  }
}
