import 'package:flutter/material.dart';

/// Token warna Body2Fit, diambil langsung dari `DESIGN.md`.
abstract final class AppColors {
  // Surface stack
  static const Color surface = Color(0xFF0D1017);
  static const Color surfaceDim = Color(0xFF0A0D13);
  static const Color surfaceBright = Color(0xFF292E3A);
  static const Color surfaceContainerLowest = Color(0xFF080A0F);
  static const Color surfaceContainerLow = Color(0xFF111520);
  static const Color surfaceContainer = Color(0xFF1A1E28);
  static const Color surfaceContainerHigh = Color(0xFF292E3A);
  static const Color surfaceContainerHighest = Color(0xFF3F3F46);

  // Foreground
  static const Color onSurface = Color(0xFFF5F5F7);
  static const Color onSurfaceVariant = Color(0xFFA1A1AA);
  static const Color inverseSurface = Color(0xFFF5F5F7);
  static const Color inverseOnSurface = Color(0xFF1A1E28);
  static const Color outline = Color(0xFF71717A);
  static const Color outlineVariant = Color(0xFF3F3F46);

  // Accents
  static const Color primary = Color(0xFFFF5D68);
  static const Color onPrimary = Color(0xFF1A0507);
  static const Color primaryContainer = Color(0xFFB91C1C);
  static const Color onPrimaryContainer = Color(0xFFFEE2E2);
  static const Color inversePrimary = Color(0xFFB91C1C);
  static const Color primaryFixed = Color(0xFFFFB3B8);

  static const Color secondary = Color(0xFF155DFC);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF1E3A6E);
  static const Color onSecondaryContainer = Color(0xFFDBE7FF);

  static const Color tertiary = Color(0xFF6A7282);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF292E3A);
  static const Color onTertiaryContainer = Color(0xFFD4D4D8);

  static const Color error = Color(0xFFFF5D68);
  static const Color onError = Color(0xFF1A0507);
  static const Color errorContainer = Color(0xFF991B1B);
  static const Color onErrorContainer = Color(0xFFFEE2E2);

  // Status
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color accentOrange = Color(0xFFFB923C);

  // Garis & overlay
  static const Color border = Color(0x1FFFFFFF); // putih 12%
  static const Color borderSubtle = Color(0x14FFFFFF); // putih 8%
  static const Color divider = Color(0x14FFFFFF); // putih 8%

  static Color tint(Color color, double alpha) => color.withValues(alpha: alpha);
}
