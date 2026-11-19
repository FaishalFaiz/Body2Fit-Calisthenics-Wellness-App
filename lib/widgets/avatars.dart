import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Wordmark Body2Fit dengan angka "2" berwarna coral.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.fontSize = 20,
    this.color = AppColors.onSurface,
    this.accentColor = AppColors.primary,
  });

  final double fontSize;
  final Color color;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: 'Body', style: TextStyle(color: color)),
          TextSpan(text: '2', style: TextStyle(color: accentColor)),
          TextSpan(text: 'Fit', style: TextStyle(color: color)),
        ],
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: -(fontSize * 0.042),
        height: 1.1,
      ),
    );
  }
}

/// Avatar inisial dengan cincin gradient coral -> cobalt.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 40,
    this.showRing = true,
    this.editable = false,
    this.onEdit,
  });

  final String initials;
  final double size;
  final bool showRing;
  final bool editable;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final double ring = size <= 40 ? 2 : 2.5;

    final Widget core = Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(showRing ? ring : 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: showRing
            ? const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[AppColors.primary, AppColors.secondary],
              )
            : null,
        color: showRing ? null : AppColors.surfaceContainerLow,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceContainerLow,
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              fontSize: size * 0.32,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );

    if (!editable) return core;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          core,
          Positioned(
            right: -2,
            bottom: -2,
            child: Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onEdit,
                child: Container(
                  width: size * 0.34,
                  height: size * 0.34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 1.6),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    size: size * 0.17,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo aplikasi di dalam lingkaran permukaan.
class LogoBadge extends StatelessWidget {
  const LogoBadge({super.key, this.size = 36, this.padding = 5});

  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceContainerLow,
        border: Border.all(color: AppColors.border),
      ),
      child: Image.asset(
        'assets/images/body2fit_logo_small.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.fitness_center_rounded,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
