import 'package:flutter/material.dart';

/// Skala tipografi Body2Fit.
///
/// Desain aslinya memakai Comfortaa (wordmark) dan Inter (seluruh teks).
/// Prototipe ini memakai font sistem agar tidak menambah aset/dependency,
/// tetapi ukuran, weight, dan tracking tetap mengikuti `DESIGN.md`.
abstract final class AppText {
  static const TextStyle wordmark = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.4,
    height: 1.1,
  );

  static const TextStyle wordmarkSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.1,
  );

  static const TextStyle display = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    height: 1.15,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle titleLg = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.35,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static const TextStyle titleSm = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle labelSm = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
  );

  /// Label eyebrow: uppercase 10px, tracking lebar.
  static const TextStyle eyebrow = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.4,
  );

  static const TextStyle number = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle numberSm = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// TextTheme default Material 3 dengan skala Body2Fit.
  static const TextTheme theme = TextTheme(
    displayLarge: display,
    displayMedium: display,
    displaySmall: wordmark,
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
      height: 1.18,
    ),
    headlineMedium: headline,
    headlineSmall: titleLg,
    titleLarge: titleLg,
    titleMedium: title,
    titleSmall: titleSm,
    bodyLarge: bodyLg,
    bodyMedium: body,
    bodySmall: bodySm,
    labelLarge: label,
    labelMedium: labelSm,
    labelSmall: eyebrow,
  );
}
