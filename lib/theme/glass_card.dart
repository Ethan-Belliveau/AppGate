import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Reusable frosted-glass card — automatically adapts to light and dark mode.
///
/// Dark:  white 7% fill + white 12% border, no shadow.
/// Light: white 75% fill + black 6% border + subtle drop shadow.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;
  /// Override the fill color. Defaults to theme-appropriate glass fill.
  final Color? fillColor;
  /// Override the border color. Defaults to theme-appropriate glass stroke.
  final Color? strokeColor;
  final double strokeWidth;
  /// Override shadows. Pass `[]` to suppress light-mode shadows explicitly.
  final List<BoxShadow>? shadows;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blur = 20,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 0.5,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final br = borderRadius ?? BorderRadius.circular(Rr.xl);

    final fill = fillColor ??
        (isDark ? AppColors.surfaceDim : AppColors.lightSurfaceDim);
    final stroke = strokeColor ??
        (isDark ? AppColors.glassStroke : AppColors.lightGlassStroke);
    final boxShadows = shadows ??
        (isDark
            ? null
            : [
                BoxShadow(
                  color: const Color(0x0F000000),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]);

    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: br,
            border: Border.all(color: stroke, width: strokeWidth),
            boxShadow: boxShadows,
          ),
          child: child,
        ),
      ),
    );
  }
}
