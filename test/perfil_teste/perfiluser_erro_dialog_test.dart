import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_page.dart';

void main() {
  testWidgets('Perfiluser exibe AlertDialog quando há erro ao buscar dados', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Perfiluser(token: 'token_erro'),
      ),
    );

    // Aguarda o build inicial
    await tester.pump();

    // Aguarda o Future.delayed do showDialog
    await tester.pump(const Duration(seconds: 1));

    // Verifica se o AlertDialog apareceu com o título e o botão "OK"
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Erro'), findsOneWidget);
    expect(find.textContaining('Erro ao buscar dados'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
  });
}
