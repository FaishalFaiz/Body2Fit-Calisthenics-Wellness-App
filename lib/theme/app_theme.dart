import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Tema Material 3 dark Body2Fit.
///
/// Hierarki permukaan dibangun secara tonal (surface -> surfaceContainer ->
/// surfaceContainerHigh), sesuai arahan `DESIGN.md`.
ThemeData buildAppTheme() {
  const ColorScheme scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    surfaceDim: AppColors.surfaceDim,
    surfaceBright: AppColors.surfaceBright,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.inverseOnSurface,
    inversePrimary: AppColors.inversePrimary,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Colors.transparent,
  );

  final ThemeData base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.surface,
    canvasColor: AppColors.surface,
    splashFactory: InkSparkle.splashFactory,
  );

  const RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  return base.copyWith(
    textTheme: AppText.theme.apply(
      bodyColor: AppColors.onSurface,
      displayColor: AppColors.onSurface,
    ),
    primaryTextTheme: AppText.theme.apply(
      bodyColor: AppColors.onPrimary,
      displayColor: AppColors.onPrimary,
    ),
    iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant, size: 20),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      toolbarHeight: 56,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      ),
      iconTheme: IconThemeData(color: AppColors.onSurface, size: 22),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 80,
      backgroundColor: AppColors.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.primary.withValues(alpha: 0.18),
      indicatorShape: const StadiumBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final bool selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: 22,
          color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final bool selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.onSurface : AppColors.onSurfaceVariant,
        );
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: AppText.bodySm.copyWith(
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.55),
      ),
      labelStyle: AppText.bodySm.copyWith(color: AppColors.onSurfaceVariant),
      errorStyle: AppText.caption.copyWith(color: AppColors.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
        disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.5),
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: buttonShape,
        textStyle: AppText.label,
        elevation: 0,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(0, 48),
        shape: buttonShape,
        elevation: 0,
        textStyle: AppText.label,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        minimumSize: const Size(0, 48),
        shape: buttonShape,
        side: const BorderSide(color: AppColors.outlineVariant),
        textStyle: AppText.label,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppText.label,
        minimumSize: const Size(0, 36),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.onSurfaceVariant,
        minimumSize: const Size(40, 40),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.onPrimary
            : AppColors.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.primary
            : AppColors.surfaceContainerHighest;
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      trackOutlineWidth: const WidgetStatePropertyAll(0),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.transparent;
      }),
      checkColor: const WidgetStatePropertyAll(AppColors.onPrimary),
      side: const BorderSide(color: AppColors.outlineVariant, width: 1.4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.surfaceContainerHighest,
      circularTrackColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.surfaceContainerHigh,
      elevation: 0,
      contentTextStyle: AppText.bodySm.copyWith(color: AppColors.onSurface),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: AppColors.border),
      ),
      insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: AppColors.border),
      ),
      titleTextStyle: AppText.title,
      contentTextStyle: AppText.body,
      alignment: Alignment.center,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColors.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.primary,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.onSurfaceVariant,
      textColor: AppColors.onSurface,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      textStyle: AppText.caption.copyWith(color: AppColors.onSurface),
    ),
  );
}
