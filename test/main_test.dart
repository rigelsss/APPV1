import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/menu/alterarEmail/alterar_email.dart';

import 'package:sudema_app/screens/diversos/splash_screen.dart';
import 'package:sudema_app/screens/login/login.dart';

void main() {
  Future<void> _navigateTo(WidgetTester tester, Widget page) async {
    await tester.pumpWidget(MaterialApp(home: Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
          },
          child: const Text('Go'),
        );
      },
    )));
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
  }

  testWidgets('Navega para EditarEmail', (tester) async {
    await _navigateTo(tester, const EditarEmail());
    expect(find.byType(EditarEmail), findsOneWidget);
  });

}
