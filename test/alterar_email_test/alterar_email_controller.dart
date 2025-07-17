import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/menu/alterarEmail/form/alterar_email_form.dart';


void main() {
  testWidgets('Renderiza todos os campos e botão em AlterarEmailForm', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AlterarEmailForm(),
        ),
      ),
    );

    // Verifica se os campos e o botão estão na tela
    expect(find.byKey(const Key('senhaField')), findsOneWidget);
    expect(find.byKey(const Key('novoEmailField')), findsOneWidget);
    expect(find.byKey(const Key('confirmarEmailField')), findsOneWidget);
    expect(find.byKey(const Key('submitButton')), findsOneWidget);

    // Verifica se os textos estão sendo exibidos corretamente
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Novo e-mail'), findsOneWidget);
    expect(find.text('Confirme o novo e-mail'), findsOneWidget);
    expect(find.text('Confirmar alteração de e-mail'), findsOneWidget);
  });
  testWidgets('Alterna visibilidade da senha ao clicar no ícone do olho', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AlterarEmailForm(),
        ),
      ),
    );

    // O ícone inicial deve ser visibility_off (senha oculta)
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsNothing);

    // Clica no ícone do olho para mostrar a senha
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pumpAndSettle();

    // Agora o ícone deve ser visibility (senha visível)
    expect(find.byIcon(Icons.visibility), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsNothing);

    // Clica novamente para ocultar a senha
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pumpAndSettle();

    // Ícone volta a ser visibility_off
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsNothing);
  });

  testWidgets('Validação dos campos do formulário de alterar email', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AlterarEmailForm(),
        ),
      ),
    );

    // Clique no botão para forçar a validação com campos vazios
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle();

    // Espera as mensagens de erro para campos vazios
    expect(find.text('Informe a senha atual'), findsOneWidget);
    expect(find.text('Informe o novo e-mail'), findsOneWidget);
    expect(find.text('Confirme o novo e-mail'), findsWidgets);

    await tester.enterText(find.byKey(const Key('senhaField')), 'senha123');
    await tester.enterText(find.byKey(const Key('novoEmailField')), 'novo@email.com');
    await tester.enterText(find.byKey(const Key('confirmarEmailField')), 'diferente@email.com');

    // Tenta enviar novamente para validar
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle();

    // Espera mensagem de erro que os e-mails não coincidem
    expect(find.text('Os e-mails não coincidem'), findsOneWidget);
  });

}
