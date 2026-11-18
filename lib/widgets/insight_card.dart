import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_progress_bar.dart';
import 'surface_card.dart';

/// Kartu metrik dashboard: label, ikon berwarna, nilai besar, progress, target.
class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.label,
    required this.icon,
    required this.accent,
    required this.value,
    required this.unit,
    required this.progress,
    required this.footer,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final String value;
  final String unit;
  final double progress;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      shadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  style: AppText.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                value,
                style: AppText.number.copyWith(color: AppColors.onSurface),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppText.caption.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppProgressBar(value: progress, color: accent, height: 6),
          const SizedBox(height: 6),
          Text(
            footer,
            maxLines: 2,
            style: AppText.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
