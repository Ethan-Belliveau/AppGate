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

// ── Color tokens ──────────────────────────────────────────────────────────────

abstract final class AppColors {
  // ── Shared brand / semantic ──────────────────────────────────────────────
  static const primary = Color(0xFF6C63FF);
  static const primaryGlow = Color(0x4D6C63FF);
  static const primaryMuted = Color(0x336C63FF);

  static const tierShort = Color(0xFF34C759);
  static const tierNormal = Color(0xFFFF9F0A);
  static const tierLong = Color(0xFFFF453A);

  // Keep these aliases so challenge screens compile unchanged
  static const blocked = Color(0xFFFF453A);
  static const unlocked = Color(0xFF34C759);
  static const warning = Color(0xFFFF9F0A);
  static const info = Color(0xFF0A84FF);

  // ── Dark mode ────────────────────────────────────────────────────────────
  static const background = Color(0xFF050508);
  static const surface = Color(0xFF0D0D14);
  static const surfaceVariant = Color(0xFF151520);

  // Glass layers (use inside BackdropFilter)
  static const surfaceDim = Color(0x12FFFFFF); // white ~7%
  static const glassStroke = Color(0x1FFFFFFF); // white ~12%
  static const glassStrokeMed = Color(0x33FFFFFF); // white ~20%
  static const border = Color(0x1FFFFFFF);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0x99FFFFFF); // 60%
  static const textMuted = Color(0x4DFFFFFF); // 30%

  // ── Light mode ───────────────────────────────────────────────────────────
  static const lightBackground = Color(0xFFF2F2F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF5F5F7);

  // Glass layers for light mode
  static const lightSurfaceDim = Color(0xBFFFFFFF); // white 75%
  static const lightGlassStroke = Color(0x0F000000); // black ~6%

  static const lightTextPrimary = Color(0xFF1C1C1E);
  static const lightTextSecondary = Color(0xFF6C6C70);
  static const lightTextMuted = Color(0xFFC7C7CC);

  // ── Legacy aliases ───────────────────────────────────────────────────────
  static const primaryDim = Color(0xFF4F46E5);
}

// ── Background gradients ──────────────────────────────────────────────────────

abstract final class AppBg {
  static const dark = BoxDecoration(
    color: AppColors.background,
    gradient: RadialGradient(
      center: Alignment(-0.3, -0.7),
      radius: 1.4,
      colors: [Color(0xFF1E1545), Color(0xFF050508)],
      stops: [0.0, 0.65],
    ),
  );

  static const light = BoxDecoration(
    color: AppColors.lightBackground,
    gradient: RadialGradient(
      center: Alignment(0.4, -0.6),
      radius: 1.2,
      colors: [Color(0xFFEDE8FF), Color(0xFFF2F2F7)],
      stops: [0.0, 0.70],
    ),
  );

  static BoxDecoration of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

// ── Themes ────────────────────────────────────────────────────────────────────

abstract final class AppTheme {
  // ─────────────────────────────────────────────────────────────────────────
  // DARK
  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final inter = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      brightness: Brightness.dark,
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
      textTheme: _buildTextTheme(inter, AppColors.textPrimary,
          AppColors.textSecondary, AppColors.textMuted),
      appBarTheme: _appBarTheme(AppColors.textPrimary, AppColors.textSecondary),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(AppColors.glassStroke),
      listTileTheme:
          _listTileTheme(AppColors.textPrimary, AppColors.textSecondary),
      dividerTheme: const DividerThemeData(
          color: AppColors.glassStroke, thickness: 0.5, space: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s
                .contains(WidgetState.selected)
            ? AppColors.primary
            : const Color(0x66FFFFFF)),
        trackColor: WidgetStateProperty.resolveWith((s) => s
                .contains(WidgetState.selected)
            ? AppColors.primary.withValues(alpha: 0.35)
            : const Color(0x1AFFFFFF)),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      navigationBarTheme: _navBarTheme(
        AppColors.primary,
        AppColors.textMuted,
        Colors.transparent,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // LIGHT
  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final inter = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.info,
        onSecondary: Colors.white,
        error: AppColors.blocked,
        onError: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        surfaceContainerHighest: AppColors.lightSurfaceVariant,
        outline: AppColors.lightGlassStroke,
      ),
      textTheme: _buildTextTheme(inter, AppColors.lightTextPrimary,
          AppColors.lightTextSecondary, AppColors.lightTextMuted),
      appBarTheme:
          _appBarTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(AppColors.lightGlassStroke),
      listTileTheme: _listTileTheme(
          AppColors.lightTextPrimary, AppColors.lightTextSecondary),
      dividerTheme: const DividerThemeData(
          color: AppColors.lightGlassStroke, thickness: 0.5, space: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.primary
                : Colors.grey.shade400),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.primary.withValues(alpha: 0.35)
                : Colors.grey.shade200),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      navigationBarTheme: _navBarTheme(
        AppColors.primary,
        AppColors.lightTextMuted,
        Colors.transparent,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared builders
  // ─────────────────────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(
      TextTheme inter, Color primary, Color secondary, Color muted) {
    return inter.copyWith(
      displayLarge: inter.displayLarge
          ?.copyWith(color: primary, fontWeight: FontWeight.w700, letterSpacing: -1.0),
      headlineLarge: inter.headlineLarge
          ?.copyWith(color: primary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineMedium: inter.headlineMedium
          ?.copyWith(color: primary, fontWeight: FontWeight.w600, letterSpacing: -0.3),
      titleLarge: inter.titleLarge
          ?.copyWith(color: primary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleMedium:
          inter.titleMedium?.copyWith(color: primary, fontWeight: FontWeight.w600),
      bodyLarge: inter.bodyLarge?.copyWith(color: secondary, height: 1.6),
      bodyMedium: inter.bodyMedium?.copyWith(color: secondary, height: 1.5),
      labelLarge: inter.labelLarge
          ?.copyWith(color: primary, fontWeight: FontWeight.w600, letterSpacing: 0.2),
      labelSmall:
          inter.labelSmall?.copyWith(color: muted, letterSpacing: 0.8),
    );
  }

  static AppBarTheme _appBarTheme(Color title, Color icon) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
          color: title, fontSize: 18, fontWeight: FontWeight.w700,
          letterSpacing: -0.5),
      iconTheme: IconThemeData(color: icon),
    );
  }

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rr.md)),
        textStyle: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Color stroke) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: stroke),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rr.md)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  static ListTileThemeData _listTileTheme(Color title, Color subtitle) {
    return ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: subtitle,
      titleTextStyle:
          TextStyle(color: title, fontSize: 15, fontWeight: FontWeight.w500),
      subtitleTextStyle: TextStyle(color: subtitle, fontSize: 13),
    );
  }

  static NavigationBarThemeData _navBarTheme(
      Color selected, Color unselected, Color bg) {
    return NavigationBarThemeData(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      indicatorColor: AppColors.primary.withValues(alpha: 0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: selected, size: 22);
        }
        return IconThemeData(color: unselected, size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
              color: selected, fontSize: 11, fontWeight: FontWeight.w600);
        }
        return TextStyle(
            color: unselected, fontSize: 11, fontWeight: FontWeight.w500);
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 68,
    );
  }
}
