import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Pantalla de consola retro (estado vacío de la web): marco CRT con
/// scanlines, texto verde fosforescente y cursor de bloque parpadeante.
class ConsoleScreen extends StatefulWidget {
  final List<String> lines;
  const ConsoleScreen({super.key, required this.lines});

  @override
  State<ConsoleScreen> createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: DevColors.consoleFrame,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x38DC7A44),
            blurRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: DevColors.consoleBg,
          borderRadius: BorderRadius.circular(3),
          boxShadow: const [
            BoxShadow(
              color: Color(0xE6000000),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: _Scanlines())),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final line in widget.lines)
                      Text(
                        line,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DevTheme.mono(size: 11).copyWith(
                          shadows: const [
                            Shadow(
                              color: Color(0x73A7F2B8),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 1),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '>',
                          style: DevTheme.mono(size: 11).copyWith(
                            shadows: const [
                              Shadow(color: Color(0x73A7F2B8), blurRadius: 6),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        AnimatedBuilder(
                          animation: _blink,
                          builder: (_, _) {
                            final on = _blink.value < 0.5;
                            return Container(
                              width: 7,
                              height: 13,
                              decoration: BoxDecoration(
                                color: on
                                    ? DevColors.consoleGreen
                                    : Colors.transparent,
                                boxShadow: on
                                    ? const [
                                        BoxShadow(
                                          color: Color(0x997EF29A),
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Scanlines horizontales finas tipo CRT.
class _Scanlines extends CustomPainter {
  const _Scanlines();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x13FFFFFF);
    for (var y = 0.0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Scanlines oldDelegate) => false;
}

/// Ráfaga de confeti tipo "like" de la web: partículas doradas/crema que
/// salen desde el corazón y caen con gravedad. Se dispara una vez por `tick`.
class ConfettiBurst extends StatefulWidget {
  final int tick;
  final Offset origin;
  final VoidCallback onDone;
  const ConfettiBurst({
    super.key,
    required this.tick,
    required this.origin,
    required this.onDone,
  });

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..forward();

  static final _rand = math.Random(42);
  late final List<_Particle> _particles = List.generate(30, (i) {
    final angle = _rand.nextDouble() * math.pi * 2;
    final speed = 60 + _rand.nextDouble() * 130;
    final colors = const [
      DevColors.gold,
      DevColors.goldSoft,
      DevColors.cream,
      Color(0xFF7EF29A),
      Color(0xFFDC7A44),
    ];
    return _Particle(
      velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 90),
      size: 3 + _rand.nextDouble() * 5,
      color: colors[_rand.nextInt(colors.length)],
      spin: _rand.nextDouble() * 6 - 3,
    );
  });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) {
          if (_c.isCompleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onDone();
            });
          }
          return CustomPaint(
            painter: _ConfettiPainter(
              particles: _particles,
              origin: widget.origin,
              t: _c.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Particle {
  final Offset velocity;
  final double size;
  final Color color;
  final double spin;
  const _Particle({
    required this.velocity,
    required this.size,
    required this.color,
    required this.spin,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset origin;
  final double t;
  const _ConfettiPainter({
    required this.particles,
    required this.origin,
    required this.t,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const g = 420.0;
    for (final p in particles) {
      final pos = Offset(
        origin.dx + p.velocity.dx * t + (t * t) * 0 * 0,
        origin.dy + p.velocity.dy * t + 0.5 * g * t * t,
      );
      final alpha = (1 - t) * 255;
      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.spin * t * 6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size * 1.6,
            height: p.size,
          ),
          const Radius.circular(1),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => t != old.t;
}