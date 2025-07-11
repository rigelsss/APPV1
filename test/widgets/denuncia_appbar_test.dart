import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/screens/widgets/appbar_denuncia.dart';

void main() {
  group('DenunciaAppBar', () {
    Future<void> buildApp(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(appBar: const DenunciaAppBar()),
          routes: {
            '/login': (context) => const SizedBox(key: Key('loginPage')),
            '/notificacoes': (context) => const SizedBox(key: Key('notificacoesPage')),
          },
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('exibe título "Denunciar"', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await buildApp(tester);
      expect(find.text('Denunciar'), findsOneWidget);
    });

    testWidgets('mostra ícone de login quando não logado', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await buildApp(tester);
      expect(find.byIcon(Icons.login), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('navega para /login ao clicar no ícone de login', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await buildApp(tester);

      await tester.tap(find.byIcon(Icons.login));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('loginPage')), findsOneWidget);
    });
  });
}
