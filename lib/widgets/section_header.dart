import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Judul seksi dengan ikon kecil dan aksi opsional di kanan.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.label,
    this.icon,
    this.iconColor = AppColors.primary,
    this.actionLabel,
    this.onAction,
    this.padding = EdgeInsets.zero,
  });

  final String label;
  final IconData? icon;
  final Color iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppText.eyebrow.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          if (actionLabel != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  actionLabel!,
                  style: AppText.bodySm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
