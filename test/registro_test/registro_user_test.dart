import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/registerUser/ConfirmarRegistro.dart';
import 'package:sudema_app/screens/registerUser/RegistroUser.dart';

void main() {
  testWidgets('Mostrar erro quando campos obrigatórios estão vazios', (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(800, 1200)),
        child: MaterialApp(
          home: RegistroUser(),
        ),
      ),
    );

    final criarContaButton = find.text('Criar Conta');
    expect(criarContaButton, findsOneWidget);

    await tester.ensureVisible(criarContaButton);
    await tester.tap(criarContaButton);
    await tester.pumpAndSettle();

    expect(find.text('Digite o nome completo (nome e sobrenome)'), findsOneWidget);
    expect(find.text('CPF é obrigatório'), findsOneWidget);
    expect(find.text('Contato é obrigatório'), findsOneWidget);
    expect(find.text('E-mail é obrigatório'), findsOneWidget);
    expect(find.text('Senha é obrigatória'), findsOneWidget);
    expect(find.text('Confirmação de senha é obrigatória'), findsOneWidget);
    expect(find.text('Você deve aceitar os termos para continuar.'), findsOneWidget);
  });
  testWidgets('Mostrar erro quando o nome estiver incompleto', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistroUser()));

    await tester.enterText(find.byType(TextField).at(0), 'Lukas'); // Apenas o primeiro nome
    final criarConta = find.text('Criar Conta');
    await tester.ensureVisible(criarConta);
    await tester.tap(criarConta);
    await tester.pumpAndSettle();

    expect(find.text('Digite o nome completo (nome e sobrenome)'), findsOneWidget);
  });

  testWidgets('Mostrar erro quando o CPF for inválido', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistroUser()));

    await tester.enterText(find.byType(TextField).at(0), 'User Test');
    await tester.enterText(find.byType(TextField).at(1), '123.456.789-00'); // CPF inválido
    await tester.enterText(find.byType(TextField).at(2), '(83) 91234-5678');
    await tester.enterText(find.byType(TextField).at(3), 'UserTest@example.com');
    await tester.enterText(find.byType(TextField).at(4), 'Senha@123');
    await tester.enterText(find.byType(TextField).at(5), 'Senha@123');

    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    final criarConta = find.text('Criar Conta');
    await tester.ensureVisible(criarConta);
    await tester.tap(criarConta);
    await tester.pumpAndSettle();

    expect(find.text('CPF inválido'), findsOneWidget);
  });

  testWidgets('Teste de erro de contatos', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistroUser()));

    await tester.enterText(find.byType(TextField).at(0), 'User Test');
    await tester.enterText(find.byType(TextField).at(1), '800.058.030-63'); //cpf valido
    await tester.enterText(find.byType(TextField).at(2), ''); // Contato vazio
    await tester.enterText(find.byType(TextField).at(3), 'UserTest@example.com');
    await tester.enterText(find.byType(TextField).at(4), 'Senha@123');
    await tester.enterText(find.byType(TextField).at(5), 'Senha@123');

    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);

    final criarConta = find.text('Criar Conta');
    await tester.ensureVisible(criarConta);
    await tester.tap(criarConta);

    await tester.pumpAndSettle();

    // Verificar se erro aparece
    expect(find.text('Contato é obrigatório'), findsOneWidget);
  });

  testWidgets('Mostrar erro quando o e-mail estiver vazio', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistroUser()));

    // Preencher todos os campos corretamente, menos o e-mail (deixar vazio)
    await tester.enterText(find.byType(TextField).at(0), 'User Test');
    await tester.enterText(find.byType(TextField).at(1), '800.058.030-63'); // CPF válido
    await tester.enterText(find.byType(TextField).at(2), '(99) 99999-9999'); // Contato válido
    await tester.enterText(find.byType(TextField).at(3), ''); // E-mail vazio
    await tester.enterText(find.byType(TextField).at(4), 'Senha@123');
    await tester.enterText(find.byType(TextField).at(5), 'Senha@123');

    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);

    final criarConta = find.text('Criar Conta');
    await tester.ensureVisible(criarConta);
    await tester.tap(criarConta);

    await tester.pumpAndSettle();

    // Verificar se erro aparece
    expect(find.text('E-mail é obrigatório'), findsOneWidget);
  });

  testWidgets('Mostrar erro quando a senha estiver vazia ou fraca', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistroUser()));

    // Caso 1: senha vazia
    await tester.enterText(find.byType(TextField).at(0), 'User Test');
    await tester.enterText(find.byType(TextField).at(1), '123.456.789-09');
    await tester.enterText(find.byType(TextField).at(2), '(99) 99999-9999');
    await tester.enterText(find.byType(TextField).at(3), 'UserTest@example.com');
    await tester.enterText(find.byType(TextField).at(4), ''); // senha vazia
    await tester.enterText(find.byType(TextField).at(5), ''); // confirmar senha vazia

    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);

    final criarConta = find.text('Criar Conta');
    await tester.ensureVisible(criarConta);
    await tester.tap(criarConta);
    await tester.pumpAndSettle();

    expect(find.text('Senha é obrigatória'), findsOneWidget);
    expect(find.text('Confirmação de senha é obrigatória'), findsOneWidget);

    // Caso 2: senha fraca
    await tester.enterText(find.byType(TextField).at(4), '12345678'); // senha fraca
    await tester.enterText(find.byType(TextField).at(5), '12345678'); // confirmar senha igual

    await tester.tap(criarConta);
    await tester.pumpAndSettle();

    expect(
      find.text('A senha deve ter no mínimo 8 caracteres, incluir letras, números e caracteres especiais.'),
      findsOneWidget,
    );
  });

  testWidgets('Mostrar erro quando as senhas não coincidem', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistroUser()));

    await tester.enterText(find.byType(TextField).at(0), 'User Test');
    await tester.enterText(find.byType(TextField).at(1), '123.456.789-09');
    await tester.enterText(find.byType(TextField).at(2), '(99) 99999-9999');
    await tester.enterText(find.byType(TextField).at(3), 'UserTest@example.com');
    await tester.enterText(find.byType(TextField).at(4), 'Senha@123');       // senha
    await tester.enterText(find.byType(TextField).at(5), 'SenhaDiferente'); // confirmar senha diferente

    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);

    final criarConta = find.text('Criar Conta');
    await tester.ensureVisible(criarConta);
    await tester.tap(criarConta);

    await tester.pump(); // permite que o SnackBar apareça

    expect(find.text('As senhas não coincidem.'), findsOneWidget);
  });

  testWidgets('Mostrar erro quando os termos não forem aceitos', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistroUser()));

    await tester.enterText(find.byType(TextField).at(0), 'User Test');
    await tester.enterText(find.byType(TextField).at(1), '123.456.789-09');
    await tester.enterText(find.byType(TextField).at(2), '(99) 99999-9999');
    await tester.enterText(find.byType(TextField).at(3), 'UserTest@example.com');
    await tester.enterText(find.byType(TextField).at(4), 'Senha@123');
    await tester.enterText(find.byType(TextField).at(5), 'Senha@123');

    // checkbox não marcado (por padrão falso)

    final criarConta = find.text('Criar Conta');
    await tester.ensureVisible(criarConta);
    await tester.tap(criarConta);

    await tester.pumpAndSettle();

    expect(find.text('Você deve aceitar os termos para continuar.'), findsOneWidget);
  });

  // testWidgets('Cadastro com sucesso', (WidgetTester tester) async{
  //   await tester.pumpWidget(MaterialApp(home: RegistroUser()));
  //
  //   await tester.enterText(find.byType(TextField).at(0), 'User Test');
  //   await tester.enterText(find.byType(TextField).at(1), '123.456.789-09');
  //   await tester.enterText(find.byType(TextField).at(2), '(99) 99999-9999');
  //   await tester.enterText(find.byType(TextField).at(3), 'UserTest@example.com');
  //   await tester.enterText(find.byType(TextField).at(4), 'Senha@123');
  //   await tester.enterText(find.byType(TextField).at(5), 'Senha@123');
  //
  //   final criarConta = find.text('Criar Conta');
  //   await tester.ensureVisible(criarConta);
  //   await tester.tap(criarConta);
  //
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byType(CodigoRegistro), findsOneWidget);
  //   expect(find.textContaining('verificação'), findsOneWidget);
  //
  // });
}
