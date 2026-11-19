import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Tombol utama coral, tinggi 48-50px, radius 12 (atau pill).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.expand = true,
    this.height = 50,
    this.pill = false,
    this.radius = 12,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool expand;
  final double height;
  final bool pill;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final Color foreground = foregroundColor ?? AppColors.onPrimary;
    final BorderRadius shape = BorderRadius.circular(pill ? 999 : radius);

    final Widget content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (textStyle ?? AppText.label).copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: textStyle?.fontSize ?? 14,
            ),
          ),
        ),
        if (trailingIcon != null) ...<Widget>[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 18, color: foreground),
        ],
      ],
    );

    return SizedBox(
      height: height,
      width: expand ? double.infinity : null,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foreground,
          disabledBackgroundColor: (backgroundColor ?? AppColors.primary)
              .withValues(alpha: 0.35),
          disabledForegroundColor: foreground.withValues(alpha: 0.5),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: shape),
        ),
        child: content,
      ),
    );
  }
}

/// Tombol sekunder: transparan dengan border tipis.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconColor,
    this.expand = true,
    this.height = 48,
    this.radius = 12,
    this.borderColor = AppColors.outlineVariant,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;
  final bool expand;
  final double height;
  final double radius;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: expand ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurface,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: 18, color: iconColor ?? AppColors.onSurface),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppText.label.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tombol pil tonal kecil, dipakai untuk aksi sekunder seperti "Detail".
class TonalPillButton extends StatelessWidget {
  const TonalPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 13, color: AppColors.primary),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: AppText.bodySm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
