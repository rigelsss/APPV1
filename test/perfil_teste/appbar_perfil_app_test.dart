import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_appbar.dart'; // ajuste o import para seu projeto

void main() {
  testWidgets('PerfilHeader exibe saudação com o primeiro nome', (WidgetTester tester) async {
    // Define um nome completo
    const nomeCompleto = 'User test';

    // Renderiza o widget em um MaterialApp para ter contexto de navegação
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: PerfilHeader(nome: nomeCompleto),
        ),
      ),
    );

    // Verifica se o texto "Olá, User" aparece
    expect(find.text('Olá, User'), findsOneWidget);

    // Como estamos na rota inicial, não deve mostrar o botão de voltar
    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });

  testWidgets('PerfilHeader exibe botão de voltar se pode voltar', (WidgetTester tester) async {
    const nomeCompleto = 'User test';

    // Aqui simulamos uma navegação empilhada para permitir voltar
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              appBar: PerfilHeader(nome: nomeCompleto),
              body: Center(
                child: ElevatedButton(
                  child: const Text('Ir para próxima tela'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: PerfilHeader(nome: nomeCompleto),
                        body: const Center(child: Text('Segunda Tela')),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Pressiona o botão para empilhar uma nova rota
    await tester.tap(find.text('Ir para próxima tela'));
    await tester.pumpAndSettle();

    // Agora na segunda tela, deve encontrar o botão de voltar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // E o texto com o nome ainda deve aparecer
    expect(find.text('Olá, User'), findsOneWidget);
  });
}
