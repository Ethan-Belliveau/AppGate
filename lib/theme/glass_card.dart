import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Reusable frosted-glass card.
/// Wrap content in this instead of a solid Container anywhere in the app.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? fillColor;
  final Color? strokeColor;
  final double strokeWidth;
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
    final br = borderRadius ?? BorderRadius.circular(Rr.xl);
    final fill = fillColor ?? AppColors.surfaceDim;
    final stroke = strokeColor ?? AppColors.glassStroke;

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
            boxShadow: shadows,
          ),
          child: child,
        ),
      ),
    );
  }
}
