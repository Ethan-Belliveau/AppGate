import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/app_tier.dart';

/// Glass-tinted pill badge for Short / Normal / Long tiers.
class TierBadge extends StatelessWidget {
  final AppTier tier;
  final bool compact;

  const TierBadge({super.key, required this.tier, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final color = tier.color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? Sp.x2 : Sp.x3,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Rr.full),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.5),
      ),
      child: Text(
        tier.label,
        style: TextStyle(
          color: color,
          fontSize: compact ? 10 : 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
