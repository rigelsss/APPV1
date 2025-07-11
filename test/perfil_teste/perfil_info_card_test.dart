import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_user_infocard.dart';

void main() {
  testWidgets('PerfilInfoCard exibe corretamente nome, e-mail, telefone e CPF formatados', (WidgetTester tester) async {
    final Map<String, dynamic> mockUserData = {
      'name': 'Test User',
      'email': 'test@example.com',
      'phone': '83991234567',
      'cpf': '12345678901',
    };

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PerfilInfoCard(userData: {
            'name': 'Test user',
            'email': 'lukas@example.com',
            'phone': '83991234567',
            'cpf': '12345678901',
          }),
        ),
      ),
    );

    // Verifica se o nome aparece
    expect(find.text('Lukas Romero'), findsOneWidget);

    // Verifica se o e-mail aparece
    expect(find.text('lukas@example.com'), findsOneWidget);

    // Verifica se o telefone está formatado
    expect(find.textContaining('99123'), findsOneWidget);

    // Verifica se o CPF está formatado
    expect(find.text('123.456.789-01'), findsOneWidget);

    // Verifica se o ícone de pessoa foi exibido
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
