import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Progress bar tipis bergaya Material 3 dengan track tonal.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.height = 6,
  });

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double progress = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: ColoredBox(color: AppColors.surfaceContainerHighest),
            ),
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
