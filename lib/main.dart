import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'theme.dart';

void main() {
  runApp(const DevPlayApp());
}

/// Raíz de la app: tema DevPlay (oscuro, "papel, tinta y filetes") y la
/// pantalla principal. Las funciones (auth, posts, chat) llegan después,
/// conectando a `localhost:8000/api/v1` — el cuadre está en el README.
class DevPlayApp extends StatelessWidget {
  const DevPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevPlay',
      debugShowCheckedModeBanner: false,
      theme: buildDevPlayTheme(),
      home: const HomeScreen(),
    );
  }
}