import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../home/today_screen.dart';
import '../apps/apps_screen.dart';
import '../tasks/task_screen.dart';
import '../you/you_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.today_outlined),
      selectedIcon: Icon(Icons.today_rounded),
      label: 'Today',
    ),
    NavigationDestination(
      icon: Icon(Icons.apps_outlined),
      selectedIcon: Icon(Icons.apps_rounded),
      label: 'Apps',
    ),
    NavigationDestination(
      icon: Icon(Icons.task_alt_outlined),
      selectedIcon: Icon(Icons.task_alt_rounded),
      label: 'Tasks',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'You',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Solid bg so nothing bleeds through on web
      backgroundColor: AppColors.background,
      // extendBody lets the gradient Stack bleed under the glass nav bar
      extendBody: true,
      body: Stack(
        children: [
          // Full-screen gradient — always beneath everything
          const Positioned.fill(
            child: DecoratedBox(decoration: AppBg.decoration),
          ),
          IndexedStack(
            index: _index,
            children: const [
              TodayScreen(),
              AppsScreen(),
              TaskScreen(),
              YouScreen(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _GlassNavBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _destinations,
      ),
    );
  }
}

/// Glass-frosted NavigationBar with blur backdrop.
class _GlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  const _GlassNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x0DFFFFFF), // white ~5%
            border: Border(
              top: BorderSide(color: AppColors.glassStroke, width: 0.5),
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
