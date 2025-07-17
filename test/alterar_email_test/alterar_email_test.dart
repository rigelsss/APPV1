import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sudema_app/screens/perfil/menu/alterarEmail/alterar_email.dart';
import 'package:sudema_app/screens/perfil/menu/alterarEmail/form/alterar_email_form.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/widgets/drawer.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {

  testWidgets('Renderiza elementos principais da tela EditarEmail', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: EditarEmail()));

    expect(find.text('Alterar e-mail'), findsOneWidget);
    expect(find.byType(AlterarEmailForm), findsOneWidget);
    expect(find.byType(NavBar), findsOneWidget);
  });

  testWidgets('Drawer abre e exibe conteúdo CustomDrawer', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: EditarEmail()));

    final scaffoldState = tester.state(find.byType(Scaffold)) as ScaffoldState;
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.byType(CustomDrawer), findsOneWidget);
  });

  testWidgets('Botão voltar da AppBar faz Navigator.pop', (tester) async {
    bool didPop = false;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditarEmail()))
                  .then((_) => didPop = true);
            },
            child: const Text('Ir para EditarEmail'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Ir para EditarEmail'));
    await tester.pumpAndSettle();

    expect(find.text('Alterar e-mail'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Ir para EditarEmail'), findsOneWidget);
    expect(didPop, isTrue);
  });

  testWidgets('Interação com o formulário AlterarEmailForm: digitar e enviar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: EditarEmail()));

    final novoEmailField = find.byKey(const Key('novoEmailField'));
    expect(novoEmailField, findsOneWidget);

    await tester.enterText(novoEmailField, 'usuario@example.com');
    await tester.pump();

    final submitButton = find.byKey(const Key('submitButton'));
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);
    await tester.pump();
  });

  testWidgets('Campo senha alterna visibilidade ao clicar no ícone', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: EditarEmail()));

    final senhaField = find.byKey(const Key('senhaField'));
    expect(senhaField, findsOneWidget);

    final iconButton = find.descendant(
      of: senhaField,
      matching: find.byType(IconButton),
    );
    expect(iconButton, findsOneWidget);

    Icon iconWidget = tester.widget<Icon>(
      find.descendant(of: iconButton, matching: find.byType(Icon)),
    );
    expect(iconWidget.icon, Icons.visibility_off);

    await tester.tap(iconButton);
    await tester.pump();

    iconWidget = tester.widget<Icon>(
      find.descendant(of: iconButton, matching: find.byType(Icon)),
    );
    expect(iconWidget.icon, Icons.visibility);

    await tester.tap(iconButton);
    await tester.pump();

    iconWidget = tester.widget<Icon>(
      find.descendant(of: iconButton, matching: find.byType(Icon)),
    );
    expect(iconWidget.icon, Icons.visibility_off);
  });
}
