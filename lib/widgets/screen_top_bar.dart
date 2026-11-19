import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Bilah atas layar dengan tombol lingkaran 40px, mengikuti referensi desain.
class ScreenTopBar extends StatelessWidget {
  const ScreenTopBar({
    super.key,
    this.titleText,
    this.title,
    this.leading,
    this.trailing = const <Widget>[],
    this.showBorder = true,
    this.centerTitle = false,
  });

  final String? titleText;
  final Widget? title;
  final Widget? leading;
  final List<Widget> trailing;
  final bool showBorder;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final Widget? titleWidget = title ??
        (titleText == null
            ? null
            : Text(
                titleText!,
                style: AppText.titleSm.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 16,
                ),
              ));

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: showBorder
            ? const Border(bottom: BorderSide(color: AppColors.borderSubtle))
            : null,
      ),
      child: Row(
        children: <Widget>[
          ?leading,
          if (leading != null) const SizedBox(width: 6),
          Expanded(
            child: titleWidget == null
                ? const SizedBox.shrink()
                : (centerTitle ? Center(child: titleWidget) : titleWidget),
          ),
          for (final Widget action in trailing) ...<Widget>[
            const SizedBox(width: 4),
            action,
          ],
        ],
      ),
    );
  }
}

/// Tombol ikon bulat 40px dengan state hover tonal.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = 40,
    this.iconSize = 21,
    this.foregroundColor = AppColors.onSurface,
    this.backgroundColor = Colors.transparent,
    this.showDot = false,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool showDot;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final Widget button = Material(
      color: filled ? AppColors.surfaceContainerHigh : Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        hoverColor: AppColors.surfaceContainerHigh,
        splashColor: AppColors.onSurface.withValues(alpha: 0.05),
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(icon, size: iconSize, color: foregroundColor),
              if (showDot)
                Positioned(
                  top: size * 0.26,
                  right: size * 0.26,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    final Widget result = backgroundColor == Colors.transparent
        ? button
        : DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: button,
          );

    if (tooltip == null) return result;
    return Tooltip(message: tooltip!, child: result);
  }
}
