import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tokens de diseño de DevPlay — mismos valores que la web (rama `visual`
/// del backend): paleta "papel, tinta y filetes" en oscuro, convertida de
/// oklch → sRGB. Fuentes: Fraunces (display), Bitter (cuerpo) y
/// JetBrains Mono (mono, reemplazo del Geist Mono de la web).
abstract final class DevColors {
  // ── Paleta semántica (dark) ────────────────────────────────
  static const background = Color(0xFF23160E); // oklch(0.215 0.026 55)
  static const foreground = Color(0xFFEEE5D3); // oklch(0.925 0.026 85)
  static const card = Color(0xFF2E1F15); // oklch(0.255 0.03 55)
  static const cardRaised = Color(0xFF37261A); // hover / superficies elevadas
  static const primary = Color(0xFFDC7A44); // oklch(0.68 0.14 48) ámbar
  static const primaryFg = Color(0xFF180C06);
  static const secondary = Color(0xFF3C2B1F);
  static const secondaryFg = Color(0xFFEEE5D3);
  static const muted = Color(0xFF3B2A1E);
  static const mutedFg = Color(0xFFA79581);
  static const accent = Color(0xFF4F2F1D);
  static const accentFg = Color(0xFFF9B189);
  static const destructive = Color(0xFFE55745);
  static const likedRed = Color(0xFFEF4444); // text-red-500 del like
  static const border = Color(0x24EEE5D3); // oklch(0.94 0.02 85 / 0.14)

  // ── Acentos de marca que la web usa sueltos en componentes ──
  static const gold = Color(0xFFD9A441);
  static const goldSoft = Color(0xFFF0D9A8);
  static const cream = Color(0xFFF6EFDE);
  static const amber = Color(0xFFD9A441);
  static const wine = Color(0xFF8E3B47);
  static const olive = Color(0xFF7A7A3E);

  // ── Consola CRT (estado vacío) ──
  static const consoleBg = Color(0xFF12100C);
  static const consoleGreen = Color(0xFF7EF29A);
  static const consoleFrame = Color(0xFF59371F); // primary 45% + negro

  // Fill con alpha (píldoras, chips, badges)
  static const white08 = Color(0x14FFFFFF);
  static const white15 = Color(0x26FFFFFF);
  static const black14 = Color(0x24000000);
  static const gold20 = Color(0x33D9A441);
  static const gold25 = Color(0x40D9A441);
  static const gold35 = Color(0x59D9A441);
  static const gold40 = Color(0x66D9A441);
  static const gold50 = Color(0x80D9A441);
}

/// Helpers de estilo compartidos por todos los widgets.
abstract final class DevTheme {
  // ── Tipografías (mismas familias que la web) ──────────────
  static TextStyle display({
    double size = 20,
    FontWeight w = FontWeight.w700,
    Color color = DevColors.foreground,
  }) =>
      GoogleFonts.fraunces(fontSize: size, fontWeight: w, color: color);

  static TextStyle body({
    double size = 14,
    FontWeight w = FontWeight.w400,
    Color color = DevColors.foreground,
    double? height,
  }) =>
      GoogleFonts.bitter(
          fontSize: size, fontWeight: w, color: color, height: height);

  static TextStyle mono({
    double size = 11,
    FontWeight w = FontWeight.w400,
    Color color = DevColors.consoleGreen,
  }) =>
      GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: w, color: color);

  static TextStyle labelCaps({
    double size = 10,
    FontWeight w = FontWeight.w700,
    Color color = DevColors.mutedFg,
  }) =>
      GoogleFonts.bitter(
          fontSize: size,
          fontWeight: w,
          color: color,
          letterSpacing: 1.4);

  // ── Superficies (glass-card / glass-strong de la web) ─────
  static BoxDecoration glass({double radius = 8, Color? color}) =>
      BoxDecoration(
        color: color ?? DevColors.card,
        border: Border.all(color: DevColors.border),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration glassStrong({double radius = 8}) => BoxDecoration(
        color: DevColors.card,
        border: Border.all(color: DevColors.border),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      );

  /// Botón "degradado" primario → acento, como .btn-gradient-primary.
  static LinearGradient btnGradient() => const LinearGradient(
        colors: [Color(0xFFE08A52), Color(0xFFC05E2E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

ThemeData buildDevPlayTheme() {
  final scheme = ColorScheme.dark(
    primary: DevColors.primary,
    onPrimary: DevColors.primaryFg,
    secondary: DevColors.secondary,
    onSecondary: DevColors.secondaryFg,
    error: DevColors.destructive,
    onError: const Color(0xFFFFFFFF),
    surface: DevColors.card,
    onSurface: DevColors.foreground,
    surfaceContainerHighest: DevColors.muted,
    onSurfaceVariant: DevColors.mutedFg,
    outline: DevColors.border,
    outlineVariant: DevColors.border,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: DevColors.background,
    canvasColor: DevColors.background,
    splashFactory: InkSparkle.splashFactory,
    textTheme: TextTheme(
      bodyMedium: DevTheme.body(),
      bodySmall: DevTheme.body(size: 12),
      titleMedium: DevTheme.body(size: 16, w: FontWeight.w600),
      labelMedium: DevTheme.labelCaps(),
    ),
    dividerTheme: const DividerThemeData(
      color: DevColors.border,
      thickness: 1,
    ),
  );
}