import 'package:flutter/material.dart';

/// Singleton ValueNotifier that drives the app-wide ThemeMode.
/// Access from anywhere — no InheritedWidget needed.
class ThemeController {
  ThemeController._();
  static final notifier = ValueNotifier<ThemeMode>(ThemeMode.dark);
}
