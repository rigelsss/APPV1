import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';

void main() {
  group('NavBar Widget Tests', () {
    testWidgets('Renderiza todos os itens do NavBar', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavBar(currentIndex: -1, onTap: (_) {}),
        ),
      ));

      for (int i = 0; i < 4; i++) {
        expect(find.byKey(Key('navbar_item_$i')), findsOneWidget);
      }
    });

    testWidgets('Dispara onTap ao clicar nos itens do NavBar', (WidgetTester tester) async {
      int? tappedIndex;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavBar(
            currentIndex: -1,
            onTap: (index) {
              tappedIndex = index;
            },
          ),
        ),
      ));

      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byKey(Key('navbar_item_$i')));
        await tester.pump();
        expect(tappedIndex, equals(i));
      }
    });

    testWidgets('Mostra label apenas no item selecionado', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavBar(currentIndex: 2, onTap: (_) {}),
        ),
      ));

      expect(find.text('Balneabilidade'), findsOneWidget); // selecionado
      expect(find.text('Início'), findsNothing); // não selecionado
      expect(find.text('Denúncias'), findsNothing);
      expect(find.text('Notícias'), findsNothing);
    });

    testWidgets('Não dispara onTap quando NavBar está desabilitado', (WidgetTester tester) async {
      bool foiChamado = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavBar(
            currentIndex: 0,
            enabled: false,
            onTap: (_) {
              foiChamado = true;
            },
          ),
        ),
      ));

      await tester.tap(find.byKey(const Key('navbar_item_1')));
      await tester.pump();

      expect(foiChamado, isFalse);
    });
  });
}
