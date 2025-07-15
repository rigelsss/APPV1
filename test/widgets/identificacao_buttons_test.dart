import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/widgets/identificacao_buttons.dart';

void main() {
  group('IdentificacaoButtons', () {
    testWidgets('Exibe botão "Acessar Sistema" quando não está logado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IdentificacaoButtons(
              isLoggedIn: false,
              email: '',
              onProsseguir: () {},
            ),
          ),
        ),
      );

      expect(find.text('Acessar Sistema'), findsOneWidget);
    });

    testWidgets('Exibe email e dois botões quando está logado', (tester) async {
      const email = 'teste@email.com';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IdentificacaoButtons(
              isLoggedIn: true,
              email: email,
              onProsseguir: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('Você acessou o sistema como:'), findsOneWidget);
      expect(find.textContaining(email), findsOneWidget);
      expect(find.text('Prosseguir com Identificação'), findsOneWidget);
      expect(find.text('Prosseguir Anônimo'), findsOneWidget);
    });

    testWidgets('Chama onProsseguir ao pressionar "Prosseguir com Identificação"', (tester) async {
      bool chamado = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IdentificacaoButtons(
              isLoggedIn: true,
              email: 'teste@email.com',
              onProsseguir: () {
                chamado = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Prosseguir com Identificação'));
      await tester.pump();

      expect(chamado, isTrue);
    });

    testWidgets('Chama onProsseguir ao pressionar "Prosseguir Anônimo"', (tester) async {
      bool chamado = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IdentificacaoButtons(
              isLoggedIn: true,
              email: 'teste@email.com',
              onProsseguir: () {
                chamado = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Prosseguir Anônimo'));
      await tester.pump();

      expect(chamado, isTrue);
    });
  });
  testWidgets('Navega para /login ao pressionar "Acessar Sistema"', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Page')),
        },
        home: Scaffold(
          body: IdentificacaoButtons(
            isLoggedIn: false,
            email: '',
            onProsseguir: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('Acessar Sistema'));
    await tester.pumpAndSettle();

    expect(find.text('Login Page'), findsOneWidget);
  });
  testWidgets('Define DenunciaData().anonimo como false ao prosseguir com identificação', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IdentificacaoButtons(
            isLoggedIn: true,
            email: 'teste@email.com',
            onProsseguir: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('Prosseguir com Identificação'));
    await tester.pump();

    expect(DenunciaData().anonimo, isFalse);
  });

  testWidgets('Define DenunciaData().anonimo como true ao prosseguir anônimo', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IdentificacaoButtons(
            isLoggedIn: true,
            email: 'teste@email.com',
            onProsseguir: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('Prosseguir Anônimo'));
    await tester.pump();

    expect(DenunciaData().anonimo, isTrue);
  });

}
