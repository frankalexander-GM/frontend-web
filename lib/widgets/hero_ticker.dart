import 'package:flutter/material.dart';

import '../theme.dart';

/// Juego de la cinta (mismo shape que /api/v1/betas del backend).
class TickerGame {
  final String title;
  final String? version;
  final String? genre;
  final int downloads;
  const TickerGame({
    required this.title,
    this.version,
    this.genre,
    this.downloads = 0,
  });
}

/// Cinta superior "★ EN DEVPLAY": píldoras de juego con portada,
/// nombre y chip de versión. Clicable → detalle de la beta (pronto).
const mockGames = [
  TickerGame(title: 'Pixel Dash', version: 'v0.4.2', genre: 'Arcade', downloads: 1284),
  TickerGame(title: 'Neon Drift', version: 'v1.1.0', genre: 'Carreras', downloads: 3421),
  TickerGame(title: 'Código Rojo', version: 'v0.9.3', genre: 'Shooter', downloads: 912),
  TickerGame(title: 'Astro Bakery', version: 'v2.0.1', genre: 'Simulación', downloads: 5870),
  TickerGame(title: 'Guardianes de Otoño', version: 'v0.3.0', genre: 'RPG', downloads: 219),
  TickerGame(title: 'Mini Mapache', version: 'v1.5.2', genre: 'Puzzle', downloads: 7642),
];

/// Hero ticker: dos cintas deslizándose en loop, calcando la web.
class HeroTicker extends StatelessWidget {
  final List<TickerGame> games;
  const HeroTicker({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: DevColors.border)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 46,
            child: Marquee(
              duration: const Duration(seconds: 26),
              child: _StripA(games: games, withLabel: true),
            ),
          ),
          SizedBox(
            height: 34,
            child: Marquee(
              duration: const Duration(seconds: 34),
              child: _StripB(games: games, withLabel: true),
            ),
          ),
        ],
      ),
    );
  }
}

/// Marquee de loop perfecto: el track lleva la MISMA secuencia 2x y la
/// animación mueve translateX(0 → -50%), como el CSS de la web.
class Marquee extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const Marquee({super.key, required this.child, this.duration = const Duration(seconds: 26)});

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration)..repeat();
  final GlobalKey _trackKey = GlobalKey();
  double? _trackWidth;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _measure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final w = _trackKey.currentContext?.size?.width;
      if (w != null && w != _trackWidth) setState(() => _trackWidth = w);
    });
  }

  @override
  Widget build(BuildContext context) {
    _measure();
    final track = Row(
      key: _trackKey,
      mainAxisSize: MainAxisSize.min,
      children: [widget.child, widget.child],
    );
    if (_trackWidth == null) {
      return ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: track,
        ),
      );
    }
    return ClipRect(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) => OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(-_c.value * _trackWidth! / 2, 0),
            child: track,
          ),
        ),
      ),
    );
  }
}

/// Cinta 1 — píldoras de juego (portada redonda + nombre + versión).
class _StripA extends StatelessWidget {
  final List<TickerGame> games;
  final bool withLabel;
  const _StripA({required this.games, this.withLabel = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (withLabel) const _Label(text: '★ EN DEVPLAY'),
        for (final g in games) _GamePill(game: g),
      ],
    );
  }
}

class _GamePill extends StatelessWidget {
  final TickerGame game;
  const _GamePill({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.only(left: 6, right: 14),
      decoration: BoxDecoration(
        color: DevColors.white08,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DevColors.gold35),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14FFFFFF),
            offset: Offset(0, 1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Portada redonda
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DevColors.gold20,
              border: Border.all(color: DevColors.gold50),
              boxShadow: const [
                BoxShadow(color: Color(0x66000000), blurRadius: 3, offset: Offset(0, 1)),
              ],
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              size: 14,
              color: DevColors.gold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            game.title,
            style: DevTheme.body(size: 11, w: FontWeight.w700, color: DevColors.cream).copyWith(
              letterSpacing: 0.4,
            ),
          ),
          if (game.version != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: DevColors.gold25,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: DevColors.gold40),
              ),
              child: Text(
                game.version!.replaceFirst(RegExp(r'^v', caseSensitive: false), 'v'),
                style: DevTheme.body(size: 8.5, w: FontWeight.w700, color: DevColors.goldSoft),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Cinta 2 — píldoras de datos (nombre + género + descargas).
class _StripB extends StatelessWidget {
  final List<TickerGame> games;
  final bool withLabel;
  const _StripB({required this.games, this.withLabel = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (withLabel) const _Label(text: '◆ LO MÁS JUGADO'),
        for (final g in games) _MetaPill(game: g),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  final TickerGame game;
  const _MetaPill({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: DevColors.black14,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DevColors.white15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            game.title,
            style: DevTheme.body(size: 10, w: FontWeight.w700, color: const Color(0xFFFFF8EC)),
          ),
          if (game.genre != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: DevColors.white15,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                game.genre!,
                style: DevTheme.body(size: 8.5, w: FontWeight.w600, color: const Color(0xE6FFFFFF)),
              ),
            ),
          ],
          if (game.downloads > 0) ...[
            const SizedBox(width: 6),
            Icon(Icons.download_rounded, size: 10, color: const Color(0xD9FFFFFF)),
            const SizedBox(width: 2),
            Text(
              _compact(game.downloads),
              style: DevTheme.body(size: 9.5, color: const Color(0xD9FFFFFF)),
            ),
          ],
        ],
      ),
    );
  }

  static String _compact(int n) {
    if (n < 1000) return '$n';
    final k = n / 1000;
    return k == k.roundToDouble() ? '${k.round()}k' : '${k.toStringAsFixed(1)}k';
  }
}

/// Etiqueta fija a la izquierda de cada cinta.
class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: DevColors.white15,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DevColors.gold35),
      ),
      child: Text(
        text,
        style: DevTheme.body(size: 10, w: FontWeight.w700, color: DevColors.cream).copyWith(
          letterSpacing: 1,
        ),
      ),
    );
  }
}