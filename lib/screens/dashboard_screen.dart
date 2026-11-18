import 'package:flutter/material.dart';

import '../core/app_router.dart';
import '../core/app_state.dart';
import '../data/mock_data.dart';
import '../models/exercise.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_badges.dart';
import '../widgets/app_buttons.dart';
import '../widgets/avatars.dart';
import '../widgets/exercise_card.dart';
import '../widgets/insight_card.dart';
import '../widgets/screen_top_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/surface_card.dart';

const List<MuscleGroup> _dashboardGroups = <MuscleGroup>[
  MuscleGroup.semua,
  MuscleGroup.push,
  MuscleGroup.pull,
  MuscleGroup.core,
];

const List<String> _dashboardGroupLabels = <String>[
  'Semua',
  'Dada & Trisep',
  'Punggung & Bisep',
  'Inti (Core)',
];

/// Tab beranda: sapaan, pencarian, metrik harian, streak, dan pilihan latihan.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  MuscleGroup _group = MuscleGroup.semua;

  void _openDetail(Exercise exercise) {
    Navigator.of(context).pushNamed(
      AppRoutes.exerciseDetail,
      arguments: exercise.code,
    );
  }

  void _startWorkout(Exercise exercise) {
    Navigator.of(context).pushNamed(
      AppRoutes.workout,
      arguments: exercise.code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final ActivityStats stats = state.stats;
    final UserProfile user = state.user;

    final int groupIndex = _dashboardGroups.indexOf(_group);
    final List<Exercise> visible = _group == MuscleGroup.semua
        ? state.featuredExercises
        : state.filter(group: _group).take(3).toList(growable: false);

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SafeArea(
              bottom: false,
              child: _DashboardHeader(
                user: user,
                onNotifications: () => widget.onOpenTab(2),
                onProfile: () => widget.onOpenTab(3),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                children: <Widget>[
                  _SearchEntry(onTap: () => widget.onOpenTab(1)),
                  const SizedBox(height: 16),
                  SectionHeader(
                    label: 'Aktivitas & Kesehatan Tubuh',
                    icon: Icons.monitor_heart_outlined,
                    actionLabel: 'Lihat Rapor',
                    onAction: () => widget.onOpenTab(2),
                  ),
                  const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: InsightCard(
                            label: 'Energi Terbakar',
                            icon: Icons.local_fire_department_rounded,
                            accent: AppColors.primary,
                            value: '${stats.caloriesBurned}',
                            unit: 'kkal',
                            progress: stats.calorieProgress,
                            footer: 'Target harian ${stats.calorieTarget} kkal',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InsightCard(
                            label: 'Waktu Latihan',
                            icon: Icons.timer_outlined,
                            accent: AppColors.secondary,
                            value: '${stats.activeMinutes}',
                            unit: 'menit',
                            progress: stats.minuteProgress,
                            footer: 'Target harian ${stats.minuteTarget} menit',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _StreakBanner(
                    stats: stats,
                    onDetail: () => widget.onOpenTab(2),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'PILIHAN LATIHAN HARI INI',
                              style: AppText.eyebrow.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Mulai Workout Calisthenics',
                              style: AppText.title.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => widget.onOpenTab(1),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            'Semua (${state.exercises.length})',
                            style: AppText.bodySm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Transform.translate(
                    offset: const Offset(-16, 0),
                    child: FilterChipRow(
                      labels: _dashboardGroupLabels,
                      selectedIndex: groupIndex < 0 ? 0 : groupIndex,
                      onSelected: (int index) {
                        setState(() => _group = _dashboardGroups[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (visible.isEmpty)
                    _EmptySelection(
                      onReset: () => setState(() => _group = MuscleGroup.semua),
                    )
                  else
                    for (int i = 0; i < visible.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == visible.length - 1 ? 0 : 10,
                        ),
                        child: ExerciseCard(
                          exercise: visible[i],
                          badge: _group == MuscleGroup.semua && i == 0
                              ? 'Populer'
                              : null,
                          onTap: () => _openDetail(visible[i]),
                          onStart: () => _startWorkout(visible[i]),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: _StartWorkoutFab(
            onPressed: visible.isEmpty
                ? null
                : () => _startWorkout(visible.first),
          ),
        ),
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.user,
    required this.onNotifications,
    required this.onProfile,
  });

  final UserProfile user;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: <Widget>[
          Tooltip(
            message: 'Buka profil',
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onProfile,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    user.initials,
                    style: AppText.titleSm.copyWith(
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        'Halo Atlet,',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    AppBadge(
                      label: 'M3 PRO',
                      tone: BadgeTone.primary,
                      compact: true,
                      showBorder: false,
                      uppercase: true,
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.title.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 15.5,
                  ),
                ),
              ],
            ),
          ),
          CircleIconButton(
            icon: Icons.notifications_none_rounded,
            onPressed: onNotifications,
            showDot: true,
            tooltip: 'Notifikasi',
          ),
          const SizedBox(width: 4),
          const LogoBadge(size: 36),
        ],
      ),
    );
  }
}

class _SearchEntry extends StatelessWidget {
  const _SearchEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        hoverColor: AppColors.surfaceContainerHighest,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Cari gerakan calisthenics & workout...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.tune_rounded, size: 18, color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  const _StreakBanner({required this.stats, required this.onDetail});

  final ActivityStats stats;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      color: AppColors.surfaceContainerLow,
      hoverColor: AppColors.surfaceContainerLow,
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Konsistensi: ${stats.streakDays} Hari Beruntun!',
                  style: AppText.bodySm.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    style: AppText.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                    children: <InlineSpan>[
                      const TextSpan(text: 'Kesiapan Otot Tubuh: '),
                      TextSpan(
                        text: 'Optimal (${stats.readinessPercent}%)',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TonalPillButton(label: 'Detail', onPressed: onDetail),
        ],
      ),
    );
  }
}

class _StartWorkoutFab extends StatelessWidget {
  const _StartWorkoutFab({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: PrimaryButton(
        label: 'Mulai Workout',
        icon: Icons.play_arrow_rounded,
        expand: false,
        height: 54,
        radius: 16,
        onPressed: onPressed,
        textStyle: AppText.bodySm.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _EmptySelection extends StatelessWidget {
  const _EmptySelection({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.search_off_rounded,
            size: 28,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada latihan pada kategori ini.',
            style: AppText.bodySm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          TonalPillButton(label: 'Tampilkan semua', onPressed: onReset),
        ],
      ),
    );
  }
}


