import 'package:flutter/material.dart';

import '../core/app_router.dart';
import '../core/app_state.dart';
import '../models/exercise.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_badges.dart';
import '../widgets/app_buttons.dart';
import '../widgets/exercise_card.dart';
import '../widgets/surface_card.dart';

/// Tab katalog: pencarian real-time, filter kelompok otot, dan daftar seluruh
/// gerakan. Membuka detail atau langsung memulai sesi latihan.
class ExerciseCatalogScreen extends StatefulWidget {
  const ExerciseCatalogScreen({super.key});

  @override
  State<ExerciseCatalogScreen> createState() => _ExerciseCatalogScreenState();
}

class _ExerciseCatalogScreenState extends State<ExerciseCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  MuscleGroup _group = MuscleGroup.semua;
  String _query = '';

  static const List<MuscleGroup> _groups = <MuscleGroup>[
    MuscleGroup.semua,
    MuscleGroup.push,
    MuscleGroup.pull,
    MuscleGroup.core,
    MuscleGroup.legs,
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _reset() {
    _searchController.clear();
    setState(() {
      _query = '';
      _group = MuscleGroup.semua;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<Exercise> results = state.filter(group: _group, query: _query);
    final int groupIndex = _groups.indexOf(_group);

    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 16, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'KATALOG LATIHAN',
                        style: AppText.eyebrow.copyWith(
                          color: AppColors.primary,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Temukan Gerakanmu',
                        style: AppText.headline.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 21,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '${results.length} Gerakan',
                    style: AppText.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CatalogSearchField(
              controller: _searchController,
              onChanged: (String value) => setState(() => _query = value),
              onClear: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
          ),
          const SizedBox(height: 12),
          FilterChipRow(
            labels: _groups.map((MuscleGroup group) => group.label).toList(),
            selectedIndex: groupIndex < 0 ? 0 : groupIndex,
            onSelected: (int index) {
              FocusScope.of(context).unfocus();
              setState(() => _group = _groups[index]);
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: results.isEmpty
                ? _CatalogEmptyState(
                    query: _query,
                    onReset: _reset,
                  )
                : ListView.separated(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: results.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      final Exercise exercise = results[index];
                      return ExerciseCard(
                        exercise: exercise,
                        variant: ExerciseCardVariant.catalog,
                        onTap: () => _openDetail(exercise),
                        onStart: () => _startWorkout(exercise),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CatalogSearchField extends StatelessWidget {
  const _CatalogSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: AppText.body.copyWith(
          color: AppColors.onSurface,
          fontSize: 13,
        ),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: 'Cari gerakan, otot, atau alat...',
        hintStyle: AppText.bodySm.copyWith(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
          fontSize: 12,
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: AppColors.primary,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (BuildContext context, TextEditingValue value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              onPressed: onClear,
              tooltip: 'Hapus pencarian',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 38, height: 38),
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            );
          },
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 44),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
      ),
    );
  }
}

class _CatalogEmptyState extends StatelessWidget {
  const _CatalogEmptyState({required this.query, required this.onReset});

  final String query;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: <Widget>[
        SurfaceCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 26,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Gerakan tidak ditemukan',
                textAlign: TextAlign.center,
                style: AppText.title.copyWith(color: AppColors.onSurface),
              ),
              const SizedBox(height: 6),
              Text(
                query.trim().isEmpty
                    ? 'Belum ada latihan pada kelompok otot ini.'
                    : 'Tidak ada hasil untuk "${query.trim()}". Coba kata kunci lain.',
                textAlign: TextAlign.center,
                style: AppText.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 14),
              TonalPillButton(
                label: 'Tampilkan semua',
                icon: Icons.refresh_rounded,
                onPressed: onReset,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
