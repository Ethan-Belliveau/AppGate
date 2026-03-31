import 'package:flutter/material.dart';
import '../../app_theme.dart';

/// Displays a real app logo fetched via Image.network.
/// Falls back to a letter avatar if the URL fails or is null.
class AppLogo extends StatelessWidget {
  final String? url;
  final String name;
  final double size;
  final double borderRadius;
  final Color? fallbackColor;

  const AppLogo({
    super.key,
    required this.url,
    required this.name,
    this.size = 44,
    this.borderRadius = 10,
    this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fb = fallbackColor ?? AppColors.primary;
    final fbBg = isDark
        ? fb.withValues(alpha: 0.14)
        : fb.withValues(alpha: 0.10);

    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fbBg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: fb,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    if (url == null) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: fbBg,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          );
        },
      ),
    );
  }
}

/// Canonical logo URLs for popular apps.
abstract final class PopularAppLogos {
  static const instagram =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/132px-Instagram_logo_2016.svg.png';
  static const tiktok =
      'https://sf16-website-login.neutral.ttwstatic.com/obj/tiktok_web_login_static/tiktok/webapp/main/webapp-desktop/8152caf0c8e8bc67ae0d.png';
  static const youtube =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/159px-YouTube_full-color_icon_%282017%29.svg.png';
  static const twitter =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/X_logo_2023_original.svg/300px-X_logo_2023_original.svg.png';
  static const snapchat =
      'https://upload.wikimedia.org/wikipedia/en/thumb/a/ad/Snapchat_logo.svg/153px-Snapchat_logo.svg.png';
  static const reddit =
      'https://www.redditinc.com/assets/images/site/reddit-logo.png';
  static const facebook =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/150px-Facebook_Logo_%282019%29.png';
  static const netflix =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Netflix_2015_logo.svg/220px-Netflix_2015_logo.svg.png';
  static const whatsapp =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/150px-WhatsApp.svg.png';
  static const linkedin =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/150px-LinkedIn_logo_initials.png';
}
