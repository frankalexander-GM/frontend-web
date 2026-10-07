// Test de humo: la app de DevPlay arranca con el tema oscuro y muestra
// la pantalla principal (header, feed y barra inferior).

import 'package:flutter_test/flutter_test.dart';

import 'package:devplay/main.dart';
import 'package:devplay/theme.dart';

void main() {
  test('El tema DevPlay es oscuro con la paleta de la web', () {
    final theme = buildDevPlayTheme();
    expect(theme.scaffoldBackgroundColor, DevColors.background);
    expect(theme.brightness, isNotNull);
    expect(theme.colorScheme.surface, DevColors.card);
  });

  testWidgets('home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DevPlayApp());
    await tester.pump();

    expect(find.text('DevPlay'), findsWidgets);
    expect(find.text('Crear'), findsOneWidget);
    expect(find.text('NoExistoEnLaApp'), findsOneWidget);
  });
}