/*(import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/perfil/controller/perfil_controller.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_page.dart';

class FakePerfilController extends PerfilController {
  FakePerfilController() {
    isLoading = false;
    errorFetching = false;
    errorMessage = '';
    userData = {}; // <- Simula vazio
    notifyListeners();
  }

}

void main() {
  testWidgets('Perfiluser mostra mensagem quando userData está vazio', (WidgetTester tester) async {
    final fakeController = FakePerfilController();

    await tester.pumpWidget(
      MaterialApp(
        home: Perfiluser(controller: fakeController),
      ),
    );

    await tester.pump();

    expect(find.text('Nenhuma informação de usuário encontrada'), findsOneWidget);
  });
}

 */