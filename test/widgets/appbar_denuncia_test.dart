import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/widgets/appbardenuncia.dart';

void main() {
  group('AppBarDenuncia', () {
    testWidgets('exibe título corretamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(appBar: AppBarDenuncia(title: 'Teste')),
        ),
      );
      expect(find.text('Teste'), findsOneWidget);
    });

    testWidgets('tem botão de voltar com ícone correto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(appBar: AppBarDenuncia(title: 'Teste')),
        ),
      );
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('botão de voltar executa Navigator.pop', (tester) async {
      bool didPop = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onPopPage: (route, result) {
              didPop = true;
              return route.didPop(result);
            },
            pages: [
              MaterialPage(child: Scaffold(appBar: AppBarDenuncia(title: 'Teste'))),
            ],
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(didPop, true);
    });
  });
}
