import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_menu_item.dart'; // ajuste o import conforme seu projeto

void main() {
  testWidgets('PerfilMenuItem exibe ícone, título e reage ao toque', (WidgetTester tester) async {
    bool foiTocado = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PerfilMenuItem(
            icon: const Icon(Icons.person),
            title: 'Editar Perfil',
            onTap: () {
              foiTocado = true;
            },
          ),
        ),
      ),
    );

    // Verifica se o título aparece
    expect(find.text('Editar Perfil'), findsOneWidget);

    // Verifica se o ícone aparece
    expect(find.byIcon(Icons.person), findsOneWidget);

    // Verifica se o ícone de seta à direita aparece
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    // Toca no item
    await tester.tap(find.byType(PerfilMenuItem));
    await tester.pumpAndSettle();

    // Verifica se a função foi chamada
    expect(foiTocado, isTrue);
  });
}
