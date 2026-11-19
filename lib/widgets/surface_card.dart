import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Permukaan dasar aplikasi: kartu tonal dengan border tipis dan opsional
/// efek hover (naik ke surfaceContainerHigh) seperti di `DESIGN.md`.
class SurfaceCard extends StatefulWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.surfaceContainer,
    this.hoverColor = AppColors.surfaceContainerHigh,
    this.borderRadius = 16,
    this.borderColor = AppColors.border,
    this.onTap,
    this.gradient,
    this.showBorder = true,
    this.shadow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color hoverColor;
  final double borderRadius;
  final Color borderColor;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final bool showBorder;
  final bool shadow;

  @override
  State<SurfaceCard> createState() => _SurfaceCardState();
}

class _SurfaceCardState extends State<SurfaceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(widget.borderRadius);
    final bool interactive = widget.onTap != null;
    final Color background = _hovered && interactive ? widget.hoverColor : widget.color;

    return MouseRegion(
      cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: widget.gradient == null ? background : null,
          gradient: widget.gradient,
          borderRadius: radius,
          border: widget.showBorder ? Border.all(color: widget.borderColor) : null,
          boxShadow: widget.shadow
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: radius,
            splashColor: AppColors.onSurface.withValues(alpha: 0.04),
            highlightColor: Colors.transparent,
            child: Padding(padding: widget.padding, child: widget.child),
          ),
        ),
      ),
    );
  }
}
