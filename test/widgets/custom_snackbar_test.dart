import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/widgets/custom_snackbar.dart';

void main() {
  testWidgets('exibe snackbar de erro com mensagem', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Placeholder(),
        ),
      ),
    );

    CustomSnackbar.erro(tester.element(find.byType(Placeholder)), 'Erro ao salvar');

    await tester.pump(); // dispara o showSnackBar
    expect(find.text('Erro ao salvar'), findsOneWidget);
  });

  testWidgets('exibe snackbar de sucesso com mensagem', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Placeholder(),
        ),
      ),
    );

    CustomSnackbar.sucesso(tester.element(find.byType(Placeholder)), 'Sucesso ao salvar');

    await tester.pump(); // dispara o showSnackBar
    expect(find.text('Sucesso ao salvar'), findsOneWidget);
  });

}
