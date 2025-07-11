import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_page.dart';

void main() {
  testWidgets('Perfiluser exibe indicador de carregamento quando está carregando', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Perfiluser(token: 'fake_token'),
      ),
    );

    // Verifica se o CircularProgressIndicator é exibido
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
