import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/exercise_meta.dart';

enum BadgeTone { primary, secondary, success, warning, neutral, onSurface }

extension BadgeToneX on BadgeTone {
  Color get color => switch (this) {
        BadgeTone.primary => AppColors.primary,
        BadgeTone.secondary => AppColors.secondary,
        BadgeTone.success => AppColors.success,
        BadgeTone.warning => AppColors.warning,
        BadgeTone.neutral => AppColors.onSurfaceVariant,
        BadgeTone.onSurface => AppColors.onSurface,
      };

  Color get background => switch (this) {
        BadgeTone.onSurface => AppColors.surfaceContainerHigh,
        BadgeTone.neutral => AppColors.surfaceContainerHigh,
        _ => color.withValues(alpha: 0.14),
      };
}

/// Label pil kecil untuk status, level, dan metadata.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = BadgeTone.neutral,
    this.icon,
    this.uppercase = false,
    this.compact = false,
    this.showBorder = true,
  });

  final String label;
  final BadgeTone tone;
  final IconData? icon;
  final bool uppercase;
  final bool compact;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final Color foreground = tone.color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(999),
        border: showBorder
            ? Border.all(color: foreground.withValues(alpha: 0.22))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 11, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            uppercase ? label.toUpperCase() : label,
            style: AppText.labelSm.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: uppercase ? 0.6 : 0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge level latihan (Pemula / Menengah / Lanjut).
class DifficultyBadge extends StatelessWidget {
  const DifficultyBadge({
    super.key,
    required this.difficulty,
    this.compact = false,
  });

  final ExerciseDifficulty difficulty;
  final bool compact;

  BadgeTone get _tone => switch (difficulty) {
        ExerciseDifficulty.pemula => BadgeTone.success,
        ExerciseDifficulty.menengah => BadgeTone.warning,
        ExerciseDifficulty.lanjut => BadgeTone.primary,
      };

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: difficulty.label,
      tone: _tone,
      compact: compact,
      showBorder: true,
    );
  }
}

/// Deretan filter chip horizontal dengan gaya desain Body2Fit.
class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: <Widget>[
          for (int i = 0; i < labels.length; i++)
            Padding(
              padding: EdgeInsets.only(right: i == labels.length - 1 ? 0 : 8),
              child: _FilterPill(
                label: labels[i],
                selected: i == selectedIndex,
                onTap: () => onSelected(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground = selected ? AppColors.onPrimary : AppColors.onSurfaceVariant;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (selected) ...<Widget>[
                Icon(Icons.check_rounded, size: 14, color: foreground),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: AppText.bodySm.copyWith(
                  color: foreground,
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

/// Chip netral untuk daftar otot / tipe gerakan pada halaman detail.
class MetaChip extends StatelessWidget {
  const MetaChip({super.key, required this.label, this.highlight = false});

  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight ? AppColors.primary.withValues(alpha: 0.25) : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppText.bodySm.copyWith(
          color: highlight ? AppColors.primary : AppColors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
