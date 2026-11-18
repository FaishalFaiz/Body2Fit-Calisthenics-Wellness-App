import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Thumbnail latihan dengan fallback aman bila aset tidak tersedia.
class ExerciseThumbnail extends StatelessWidget {
  const ExerciseThumbnail({
    super.key,
    required this.exercise,
    this.size = 80,
    this.radius = 12,
    this.badge,
    this.cornerLabel,
    this.fallbackIcon = Icons.sports_gymnastics_rounded,
  });

  final Exercise exercise;
  final double size;
  final double radius;
  final String? badge;
  final String? cornerLabel;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(size * 0.05),
            child: Image.asset(
              exercise.cardImage,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  fallbackIcon,
                  size: size * 0.38,
                  color: AppColors.primary.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  badge!.toUpperCase(),
                  style: AppText.labelSm.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          if (cornerLabel != null)
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  cornerLabel!,
                  style: AppText.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 8,
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
