import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/exercise_meta.dart';
import 'app_badges.dart';
import 'exercise_thumbnail.dart';
import 'surface_card.dart';

enum ExerciseCardVariant { dashboard, catalog }

/// Kartu latihan horizontal: thumbnail, judul, deskripsi singkat, dan
/// metadata set/reps atau aksi "Mulai Latihan".
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
    this.onStart,
    this.variant = ExerciseCardVariant.dashboard,
    this.badge,
    this.showChevron = true,
  });

  final Exercise exercise;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final ExerciseCardVariant variant;
  final String? badge;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final ExerciseMeta meta = ExerciseMeta.forExercise(exercise);
    final bool catalog = variant == ExerciseCardVariant.catalog;

    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      borderRadius: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ExerciseThumbnail(
            exercise: exercise,
            size: 84,
            radius: 12,
            badge: badge,
            cornerLabel: catalog ? null : '${meta.minutes} Min',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: catalog ? null : 84,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    catalog ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              exercise.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.titleSm.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          if (catalog)
                            DifficultyBadge(
                              difficulty: meta.difficulty,
                              compact: true,
                            )
                          else if (showChevron)
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 18,
                              color: AppColors.onSurfaceVariant,
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        exercise.description,
                        maxLines: catalog ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                  if (catalog) const SizedBox(height: 8),
                  _Footer(
                    variant: variant,
                    meta: meta,
                    onStart: onStart,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.variant,
    required this.meta,
    required this.onStart,
  });

  final ExerciseCardVariant variant;
  final ExerciseMeta meta;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    if (variant == ExerciseCardVariant.catalog) {
      return Column(
        children: <Widget>[
          const Divider(color: AppColors.divider, height: 10, thickness: 1),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  meta.volumeLabel,
                  style: AppText.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: onStart,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Mulai Latihan',
                        style: AppText.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 12,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    final Color difficultyColor = switch (meta.difficulty) {
      ExerciseDifficulty.pemula => AppColors.success,
      ExerciseDifficulty.menengah => AppColors.warning,
      ExerciseDifficulty.lanjut => AppColors.primary,
    };

    return Row(
      children: <Widget>[
        const Icon(Icons.fitness_center_rounded, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            meta.volumeLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.speed_rounded, size: 12, color: difficultyColor),
        const SizedBox(width: 4),
        Text(
          meta.difficulty.label,
          style: AppText.labelSm.copyWith(
            color: difficultyColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
