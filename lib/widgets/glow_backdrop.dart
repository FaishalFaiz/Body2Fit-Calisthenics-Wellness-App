import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Spesifikasi satu bulatan cahaya lembut di belakang konten.
class GlowSpec {
  const GlowSpec({
    required this.color,
    this.alignment = Alignment.bottomLeft,
    this.size = 320,
    this.opacity = 0.16,
  });

  final Color color;
  final Alignment alignment;
  final double size;
  final double opacity;
}

/// Latar dekoratif: tekstur grid tipis + bloom warna (coral/cobalt) yang
/// menempel di tepi layar. Dipakai pada splash, onboarding, dan auth.
class AppBackdrop extends StatelessWidget {
  const AppBackdrop({
    super.key,
    required this.child,
    this.glows = const <GlowSpec>[],
    this.showGrid = false,
  });

  final Widget child;
  final List<GlowSpec> glows;
  final bool showGrid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (showGrid)
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _GridPainter())),
          ),
        for (final GlowSpec glow in glows)
          IgnorePointer(
            child: Align(
              alignment: glow.alignment,
              child: Container(
                width: glow.size,
                height: glow.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      glow.color.withValues(alpha: glow.opacity),
                      glow.color.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        child,
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.onSurface.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    const double step = 40;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
