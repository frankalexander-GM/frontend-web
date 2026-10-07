import 'package:flutter/material.dart';

import '../theme.dart';

/// Tarjeta de vidrio de DevPlay (equivalente a `.glass-card`): fondo oscuro
/// cálido, filete sutil y sombra suave.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? color;
  const GlassCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 8,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final decor = DevTheme.glass(radius: radius, color: color);
    final content = Padding(padding: padding, child: child);
    return Container(
      decoration: decor,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(radius),
                child: content,
              ),
            ),
    );
  }
}