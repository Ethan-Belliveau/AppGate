import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── 8pt spacing grid ──────────────────────────────────────────────────────────

abstract final class Sp {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
  static const double x12 = 48;
  static const double x16 = 64;
}

// ── Border radius ─────────────────────────────────────────────────────────────

abstract final class Rr {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double full = 999;
}

// ── Color palette: Liquid Glass dark theme ────────────────────────────────────

abstract final class AppColors {
  // Backgrounds
  static const background = Color(0xFF050508);

  // Glass surfaces — use as Container.color inside BackdropFilter
  static const surfaceDim = Color(0x12FFFFFF); // white ~7%
  static const glassStroke = Color(0x1FFFFFFF); // white ~12%
  static const glassStrokeMed = Color(0x33FFFFFF); // white ~20%

  // Brand
  static const primary = Color(0xFF6C63FF);
  static const primaryGlow = Color(0x4D6C63FF); // 30% opacity

  // Tier colors
  static const tierShort = Color(0xFF34C759); // green
  static const tierNormal = Color(0xFFFF9F0A); // amber
  static const tierLong = Color(0xFFFF453A); // red

  // Semantic aliases — kept for challenge screens
  static const blocked = Color(0xFFFF453A);
  static const unlocked = Color(0xFF34C759);
  static const warning = Color(0xFFFF9F0A);
  static const info = Color(0xFF0A84FF);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0x99FFFFFF); // 60%
  static const textMuted = Color(0x4DFFFFFF); // 30%

  // Legacy solid surfaces (for screens that can't use BackdropFilter)
  static const surface = Color(0xFF0D0D14);
  static const surfaceVariant = Color(0xFF151520);
  static const border = Color(0x1FFFFFFF);

  // Kept for backward-compat
  static const primaryMuted = Color(0x336C63FF);
  static const primaryDim = Color(0xFF4F46E5);
}

// ── Full-screen background gradient ──────────────────────────────────────────

abstract final class AppBg {
  static const decoration = BoxDecoration(
    color: AppColors.background,
    gradient: RadialGradient(
      center: Alignment(-0.3, -0.7),
      radius: 1.4,
      colors: [
        Color(0xFF1E1545), // deep indigo
        Color(0xFF050508), // near-black
      ],
      stops: [0.0, 0.65],
    ),
  );
}

// ── Theme ─────────────────────────────────────────────────────────────────────

abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final inter = GoogleFonts.interTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.textPrimary,
        secondary: AppColors.info,
        onSecondary: AppColors.textPrimary,
        error: AppColors.blocked,
        onError: AppColors.textPrimary,
        surface: Color(0xFF0D0D14),
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: Color(0xFF151520),
        outline: AppColors.glassStroke,
      ),
      textTheme: inter.copyWith(
        displayLarge: inter.displayLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
        ),
        headlineLarge: inter.headlineLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: inter.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleLarge: inter.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleMedium: inter.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: inter.bodyLarge?.copyWith(
          color: AppColors.textSecondary,
          height: 1.6,
        ),
        bodyMedium: inter.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        labelLarge: inter.labelLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: inter.labelSmall?.copyWith(
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.textSecondary),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceDim,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rr.xl),
          side: const BorderSide(color: AppColors.glassStroke, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Rr.md)),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.glassStroke),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Rr.md)),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: AppColors.textSecondary,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.glassStroke,
        thickness: 0.5,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return const Color(0x66FFFFFF);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.35);
          }
          return const Color(0x1AFFFFFF);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: AppColors.primary.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 22);
          }
          return const IconThemeData(color: AppColors.textMuted, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600);
          }
          return const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500);
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 68,
      ),
    );
  }
}
