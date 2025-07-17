import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:sudema_app/screens/perfil/menu/alterarEmail/utils/alterar_email_utils.dart';

class _FakeResponse {
  final String body;
  final int statusCode;
  _FakeResponse({required this.body, required this.statusCode});
}

void main() {
  group('corrigirEncoding', () {
    test('corrige texto com acentuação incorreta', () {
      final textoOriginal = 'OlÃ¡ Mundo';
      final corrigido = corrigirEncoding(textoOriginal);
      expect(corrigido, 'Olá Mundo');
    });

    test('retorna texto original se erro no decode', () {
      final textoOriginal = 'Texto normal sem erro';
      final corrigido = corrigirEncoding(textoOriginal);
      expect(corrigido, textoOriginal);
    });
  });

  group('exibirErro', () {
    testWidgets('exibe Flushbar com mensagem corrigida', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      exibirErro(context, 'Mensagem de erro teste', teste: true);
                    },
                    child: const Text('Mostrar erro'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Mostrar erro'));
      await tester.pump();

      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('Mensagem de erro teste'), findsOneWidget);
    });
  });

  group('tratarErroResposta', () {
    testWidgets('exibe erro senha incorreta', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final response = _FakeResponse(
                body: jsonEncode({
                  'errors': [
                    {'message': 'Senha atual incorreta'}
                  ]
                }),
                statusCode: 400,
              );

              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      tratarErroResposta(context, response, teste: true);
                    },
                    child: const Text('Testar erro senha'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Testar erro senha'));
      await tester.pump();

      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('A senha informada está incorreta.'), findsOneWidget);
    });

    testWidgets('exibe erro email já cadastrado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final response = _FakeResponse(
                body: jsonEncode({
                  'errors': [
                    {'message': 'E-mail já cadastrado'}
                  ]
                }),
                statusCode: 400,
              );

              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      tratarErroResposta(context, response, teste: true);
                    },
                    child: const Text('Testar erro email'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Testar erro email'));
      await tester.pump();

      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('Este e-mail já está em uso. Tente outro.'), findsOneWidget);
    });

    testWidgets('exibe erro padrão para mensagem desconhecida', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final response = _FakeResponse(
                body: jsonEncode({
                  'errors': [
                    {'message': 'Outro erro qualquer'}
                  ]
                }),
                statusCode: 400,
              );

              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      tratarErroResposta(context, response, teste: true);
                    },
                    child: const Text('Testar erro padrão'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Testar erro padrão'));
      await tester.pump();

      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('Outro erro qualquer'), findsOneWidget);
    });

    testWidgets('exibe erro padrão para body sem errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final response = _FakeResponse(
                body: jsonEncode({'outroCampo': 'valor'}),
                statusCode: 400,
              );

              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      tratarErroResposta(context, response, teste: true);
                    },
                    child: const Text('Testar body sem errors'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Testar body sem errors'));
      await tester.pump();

      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('Erro ao alterar e-mail. Tente novamente.'), findsOneWidget);
    });

    testWidgets('exibe erro inesperado para JSON inválido', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final response = _FakeResponse(
                body: 'não é json',
                statusCode: 400,
              );

              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      tratarErroResposta(context, response, teste: true);
                    },
                    child: const Text('Testar json inválido'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Testar json inválido'));
      await tester.pump();

      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('Erro inesperado. Tente novamente.'), findsOneWidget);
    });

  });
}
