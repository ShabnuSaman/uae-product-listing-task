import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color seed = Colors.indigo;

  // Splash
  static const Color splashBg = Color(0xFF3949AB);
  static const Color splashText = Colors.white;
  static const double splashIconBgAlpha = 0.15;
  static const double splashSubtitleAlpha = 0.75;

  // Surfaces
  static const Color white = Colors.white;
  static const Color imageBg = Color(0xFFF5F5F5);         // grey[100]
  static const Color searchFill = Color(0xFFF5F5F5);      // grey[100]

  // Shimmer
  static const Color shimmerBase = Color(0xFFE0E0E0);     // grey[300]
  static const Color shimmerHighlight = Color(0xFFF5F5F5); // grey[100]

  // Text
  static const Color textBody = Color(0xFF616161);        // grey[700]
  static const Color textSecondary = Color(0xFF757575);   // grey[600]
  static const Color textMuted = Color(0xFF9E9E9E);       // grey[500]

  // Icons
  static const Color iconMuted = Color(0xFFBDBDBD);       // grey[400]
  static const Color starColor = Color(0xFFFFA000);       // amber[700]

  // AppBar
  static const Color appBarBg = Colors.white;
  static const Color appBarFg = Color(0xDD000000);        // black87
}
