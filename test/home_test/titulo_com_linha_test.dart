import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/home/titulo_com_linha.dart';

void main() {
  testWidgets('Renderiza título e linha', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TituloComLinha(titulo: 'Meu Título'),
        ),
      ),
    );

    // Verifica se o título aparece
    expect(find.text('Meu Título'), findsOneWidget);

    // Verifica se o Divider aparece
    expect(find.byType(Divider), findsOneWidget);

    // Verifica que o botão "Ver todas" NÃO aparece
    expect(find.text('Ver todas'), findsNothing);
  });

  testWidgets('Renderiza botão "Ver todas" quando verTodas=true e onVerTodas definido', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TituloComLinha(
            titulo: 'Título com botão',
            verTodas: true,
            onVerTodas: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    // Verifica se o botão aparece
    expect(find.text('Ver todas'), findsOneWidget);

    // Simula o clique no botão
    await tester.tap(find.text('Ver todas'));
    await tester.pumpAndSettle();

    // Verifica se o callback foi chamado
    expect(pressed, isTrue);
  });

  testWidgets('Não renderiza botão "Ver todas" se verTodas=true mas onVerTodas é null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TituloComLinha(
            titulo: 'Título sem callback',
            verTodas: true,
            onVerTodas: null,
          ),
        ),
      ),
    );

    // O botão não aparece pois onVerTodas é null
    expect(find.text('Ver todas'), findsNothing);
  });
}
