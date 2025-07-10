import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_menu_list.dart';


void main() {
  testWidgets('Exibe itens do menu e navega corretamente', (WidgetTester tester) async {
    final Map<String, dynamic> userData = {
      'name': 'Teste',
      'phone': '123456789',
      'cpf': '000.000.000-00',
    };

    String novoToken = '';

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/EditarEmail': (context) => Scaffold(
            appBar: AppBar(), // Adiciona botão de voltar
            body: const Text('Editar Email Page'),
          ),
          '/EditarSenha': (context) => Scaffold(
            appBar: AppBar(),
            body: const Text('Editar Senha Page'),
          ),
        },
        home: Scaffold(
          body: PerfilMenuList(
            token: 'fake_token',
            userData: userData,
            onSenhaAlterada: (t) => novoToken = t,
            isTest: true, // usa ícones padrão no lugar dos SVGs
          ),
        ),
      ),
    );

    // Verifica se os textos dos menus estão presentes
    expect(find.text('Notificações'), findsOneWidget);
    expect(find.text('Editar Perfil'), findsOneWidget);
    expect(find.text('Alterar E-mail'), findsOneWidget);
    expect(find.text('Alterar Senha'), findsOneWidget);

    // Clica em "Alterar E-mail"
    await tester.tap(find.text('Alterar E-mail'));
    await tester.pumpAndSettle();

    // Verifica se navegou para a tela de e-mail
    expect(find.text('Editar Email Page'), findsOneWidget);

    // Volta para a tela anterior
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Clica em "Alterar Senha"
    await tester.tap(find.text('Alterar Senha'));
    await tester.pumpAndSettle();

    // Verifica se navegou para a tela de senha
    expect(find.text('Editar Senha Page'), findsOneWidget);
  });
}
