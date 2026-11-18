import 'package:flutter/material.dart';

import '../core/app_router.dart';
import '../core/app_state.dart';
import '../models/exercise.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/exercise_display.dart';
import '../utils/exercise_meta.dart';
import '../widgets/app_badges.dart';
import '../widgets/app_buttons.dart';
import '../widgets/glow_backdrop.dart';
import '../widgets/screen_top_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/surface_card.dart';

/// Halaman detail: visual gerakan (statis/animated), metadata, otot target,
/// langkah eksekusi, dan CTA untuk memulai sesi.
class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseCode});

  final String exerciseCode;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  bool _animated = false;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final Exercise? exercise = state.byCode(widget.exerciseCode);

    if (exercise == null) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              ScreenTopBar(
                titleText: 'Detail Latihan',
                centerTitle: true,
                leading: CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: 'Kembali',
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text('Latihan tidak ditemukan.'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final ExerciseMeta meta = ExerciseMeta.forExercise(exercise);
    final bool bookmarked = state.isBookmarked(exercise.id);

    return Scaffold(
      body: AppBackdrop(
        glows: const <GlowSpec>[
          GlowSpec(
            color: AppColors.primary,
            alignment: Alignment.bottomLeft,
            size: 300,
            opacity: 0.09,
          ),
        ],
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              ScreenTopBar(
                titleText: 'Detail Latihan',
                centerTitle: true,
                leading: CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: 'Kembali',
                ),
                trailing: <Widget>[
                  CircleIconButton(
                    icon: bookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    foregroundColor:
                        bookmarked ? AppColors.primary : AppColors.onSurface,
                    onPressed: () => _toggleBookmark(state, exercise, bookmarked),
                    tooltip: bookmarked ? 'Hapus dari favorit' : 'Simpan ke favorit',
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: <Widget>[
                    _VisualHero(
                      exercise: exercise,
                      meta: meta,
                      animated: _animated,
                      onToggle: () => setState(() => _animated = !_animated),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            exercise.name,
                            style: AppText.headline.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: DifficultyBadge(difficulty: meta.difficulty),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      exercise.description,
                      style: AppText.body.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        for (final ExerciseTag type in exercise.types)
                          MetaChip(label: exerciseTypeLabel(type)),
                        for (final ExerciseTag category in exercise.categories)
                          MetaChip(label: exerciseCategoryLabel(category)),
                        MetaChip(
                          label: exercise.isHold ? 'Isometrik' : 'Fase Konsentrik',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _MetricsStrip(meta: meta),
                    const SizedBox(height: 20),
                    const SectionHeader(
                      label: 'Otot Target Utama',
                      icon: Icons.fitness_center_rounded,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        for (final ExerciseTag muscle in exercise.primaryMuscles)
                          MetaChip(
                            label: muscleLabel(muscle),
                            highlight: true,
                          ),
                      ],
                    ),
                    if (exercise.secondaryMuscles.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 10),
                      Text(
                        'Otot pendukung',
                        style: AppText.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          for (final ExerciseTag muscle in exercise.secondaryMuscles)
                            MetaChip(label: muscleLabel(muscle)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 22),
                    const SectionHeader(
                      label: 'Langkah Gerakan Yang Benar',
                      icon: Icons.checklist_rounded,
                    ),
                    const SizedBox(height: 12),
                    for (int i = 0; i < meta.steps.length; i++)
                      _StepTile(
                        index: i + 1,
                        step: meta.steps[i],
                        isLast: i == meta.steps.length - 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _DetailCta(
        onStart: () {
          Navigator.of(context).pushNamed(
            AppRoutes.workout,
            arguments: exercise.code,
          );
        },
      ),
    );
  }

  void _toggleBookmark(AppState state, Exercise exercise, bool bookmarked) {
    state.toggleBookmark(exercise.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          bookmarked
              ? 'Latihan dihapus dari favorit.'
              : 'Latihan disimpan ke favorit.',
        ),
      ),
    );
  }
}

class _VisualHero extends StatelessWidget {
  const _VisualHero({
    required this.exercise,
    required this.meta,
    required this.animated,
    required this.onToggle,
  });

  final Exercise exercise;
  final ExerciseMeta meta;
  final bool animated;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final String category = exercise.categories.isEmpty
        ? 'Latihan'
        : exerciseCategoryLabel(exercise.categories.first);

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[
                    Color(0x1AFF5D68),
                    Colors.transparent,
                    Color(0x12155DFC),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: animated
                      ? _GifPreview(key: const ValueKey<String>('gif'), exercise: exercise)
                      : Image.asset(
                          exercise.cardImage,
                          key: const ValueKey<String>('static'),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(
                              Icons.sports_gymnastics_rounded,
                              size: 64,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: _VisualToggle(animated: animated, onTap: onToggle),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _HeroChip(
                    label: category,
                    foreground: AppColors.primary,
                    background: AppColors.primary.withValues(alpha: 0.18),
                    borderColor: AppColors.primary.withValues(alpha: 0.3),
                    uppercase: true,
                  ),
                  const SizedBox(width: 6),
                  _HeroChip(
                    label: meta.isHold ? 'Isometrik' : 'Fase Konsentrik',
                    foreground: AppColors.onSurface,
                    background: AppColors.surfaceContainerHigh,
                    borderColor: AppColors.border,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GifPreview extends StatelessWidget {
  const _GifPreview({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 212,
          height: 212,
          padding: const EdgeInsets.all(6),
          color: const Color(0xFFF5F5F7),
          child: Image.asset(
            exercise.basicGif,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.sports_gymnastics_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VisualToggle extends StatelessWidget {
  const _VisualToggle({required this.animated, required this.onTap});

  final bool animated;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                animated ? Icons.photo_rounded : Icons.play_circle_outline_rounded,
                size: 13,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 5),
              Text(
                animated ? 'Statis' : 'Animasi',
                style: AppText.labelSm.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.label,
    required this.foreground,
    required this.background,
    required this.borderColor,
    this.uppercase = false,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color borderColor;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        uppercase ? label.toUpperCase() : label,
        style: AppText.labelSm.copyWith(
          color: foreground,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: uppercase ? 0.7 : 0,
        ),
      ),
    );
  }
}

class _MetricsStrip extends StatelessWidget {
  const _MetricsStrip({required this.meta});

  final ExerciseMeta meta;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: _MetricItem(
                icon: Icons.repeat_rounded,
                label: meta.isHold ? 'Target Tahan' : 'Target Repetisi',
                value: meta.targetLabel,
                accent: AppColors.primary,
              ),
            ),
            const VerticalDivider(
              color: AppColors.divider,
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: _MetricItem(
                icon: Icons.hourglass_empty_rounded,
                label: 'Istirahat',
                value: '${meta.restSeconds} dtk',
                accent: AppColors.secondary,
              ),
            ),
            const VerticalDivider(
              color: AppColors.divider,
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: _MetricItem(
                icon: Icons.local_fire_department_rounded,
                label: 'Kalori',
                value: '~${meta.calories}',
                accent: AppColors.accentOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: accent),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.numberSm.copyWith(
              color: AppColors.onSurface,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: AppText.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.step,
    required this.isLast,
  });

  final int index;
  final ExerciseStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              '$index',
              style: AppText.label.copyWith(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  step.title,
                  style: AppText.titleSm.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  step.body,
                  style: AppText.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.6,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCta extends StatelessWidget {
  const _DetailCta({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: PrimaryButton(
          label: 'Mulai Latihan Sekarang',
          icon: Icons.play_arrow_rounded,
          onPressed: onStart,
        ),
      ),
    );
  }
}
