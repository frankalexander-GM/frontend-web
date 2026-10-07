import 'package:flutter/material.dart';

import 'models/post.dart';
import 'theme.dart';
import 'widgets/feed_view.dart';
import 'widgets/header.dart';
import 'widgets/hero_ticker.dart';

/// Pantalla principal: header + cinta de juegos + feed + barra inferior +
/// dock de crear (igual estructura que la web).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  static const _nav = [
    (Icons.home_rounded, 'Inicio'),
    (Icons.explore_outlined, 'Explorar'),
    (Icons.auto_awesome_outlined, 'Descubrir'),
    (Icons.sports_esports_outlined, 'Betas'),
    (Icons.person_outline_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const DevHeader(),
                const HeroTicker(games: mockGames),
                Expanded(child: FeedView(posts: mockPosts)),
              ],
            ),
            // Dock de crear (bottom-center), como el CreateDock de la web.
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: Center(child: _CreateDock()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    return Container(
      decoration: BoxDecoration(
        color: DevColors.card,
        border: const Border(
          top: BorderSide(color: DevColors.border, width: 3),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              for (var i = 0; i < _nav.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _navIndex = i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _nav[i].$1,
                          size: 22,
                          color: i == _navIndex ? DevColors.gold : DevColors.mutedFg,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _nav[i].$2,
                          style: DevTheme.body(
                            size: 10,
                            w: i == _navIndex ? FontWeight.w700 : FontWeight.w400,
                            color: i == _navIndex ? DevColors.gold : DevColors.mutedFg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón "Crear" flotante (bottom-center) con menú de opciones.
class _CreateDock extends StatelessWidget {
  Future<void> _open(BuildContext context) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: DevColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: DevColors.muted,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Crear contenido',
                  style: DevTheme.display(size: 16),
                ),
              ),
            ),
            _Option(icon: Icons.sports_esports_rounded, iconColor: DevColors.amber, label: 'Subir Beta'),
            _Option(icon: Icons.videocam_outlined, iconColor: DevColors.wine, label: 'Subir Video'),
            _Option(icon: Icons.bar_chart_rounded, iconColor: DevColors.olive, label: 'Encuesta'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (action != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$action — pronto 😉')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          gradient: DevTheme.btnGradient(),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: DevColors.gold.withValues(alpha: 0.4),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: DevColors.background.withValues(alpha: 0.6),
              blurRadius: 4,
              offset: const Offset(0, 0),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, size: 22, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Crear',
              style: DevTheme.body(size: 14, w: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  const _Option({required this.icon, required this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context, label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 12),
            Text(label, style: DevTheme.body(size: 14)),
          ],
        ),
      ),
    );
  }
}