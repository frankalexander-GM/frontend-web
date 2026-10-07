/// Formato de tiempo relativo al estilo de la web (date-fns, español).
String timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inSeconds < 45) return 'hace un momento';
  if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    return m == 1 ? 'hace 1 minuto' : 'hace $m minutos';
  }
  if (diff.inHours < 24) {
    final h = diff.inHours;
    return h == 1 ? 'hace 1 hora' : 'hace $h horas';
  }
  if (diff.inDays < 7) {
    final d = diff.inDays;
    return d == 1 ? 'hace 1 día' : 'hace $d días';
  }
  if (diff.inDays < 30) {
    final w = diff.inDays ~/ 7;
    return w == 1 ? 'hace 1 semana' : 'hace $w semanas';
  }
  final mo = diff.inDays ~/ 30;
  return mo == 1 ? 'hace 1 mes' : 'hace $mo meses';
}

/// 1.2k, 48.5k … formato corto de números, como toLocaleString('es') corto.
String compactNumber(int n) {
  if (n < 1000) return '$n';
  if (n < 1_000_000) {
    final v = n / 1000;
    return v == v.roundToDouble() ? '${v.round()}k' : '${v.toStringAsFixed(1)}k';
  }
  final v = n / 1_000_000;
  return v == v.roundToDouble() ? '${v.round()}M' : '${v.toStringAsFixed(1)}M';
}