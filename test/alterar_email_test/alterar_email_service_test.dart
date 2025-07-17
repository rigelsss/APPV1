import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:sudema_app/screens/perfil/menu/alterarEmail/service/alterar_email_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;

  setUpAll(() {
    dotenv.testLoad(fileInput: 'URL_API=https://api.exemplo.com');
  });

  setUp(() {
    mockClient = MockClient();
  });

  group('UsuarioService alterarEmail - retorno da função', () {
    test('Retorna http.Response com status 200', () async {
      final token = 'token_teste';
      final id = '123';
      final senhaAtual = 'senhaAtual123';
      final novoEmail = 'novo@email.com';
      final confirmacaoEmail = 'novo@email.com';
      final baseUrl = 'https://api.exemplo.com';
      final expectedUrl = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');

      final successResponse = http.Response('{"message": "Email alterado"}', 200);

      when(() => mockClient.put(
        expectedUrl,
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => successResponse);

      final response = await UsuarioService.alterarEmail(
        token: token,
        id: id,
        senhaAtual: senhaAtual,
        novoEmail: novoEmail,
        confirmacaoEmail: confirmacaoEmail,
        client: mockClient,
      );

      expect(response, isA<http.Response>());
      expect(response.statusCode, 200);
      expect(response.body, contains('Email alterado'));
    });

    test('Retorna http.Response com status 500', () async {
      final token = 'token_teste';
      final id = '123';
      final senhaAtual = 'senhaAtual123';
      final novoEmail = 'novo@email.com';
      final confirmacaoEmail = 'novo@email.com';
      final baseUrl = 'https://api.exemplo.com';
      final expectedUrl = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');

      final errorResponse = http.Response('{"error": "Erro interno"}', 500);

      when(() => mockClient.put(
        expectedUrl,
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => errorResponse);

      final response = await UsuarioService.alterarEmail(
        token: token,
        id: id,
        senhaAtual: senhaAtual,
        novoEmail: novoEmail,
        confirmacaoEmail: confirmacaoEmail,
        client: mockClient,
      );

      expect(response.statusCode, 500);
      expect(response.body, contains('Erro interno'));
    });
  });

  test('Retorna http.Response com status 400', () async {
    final token = 'token_teste';
    final id = '123';
    final senhaAtual = 'senhaErrada';
    final novoEmail = 'email_invalido';
    final confirmacaoEmail = 'outro@email.com';
    final baseUrl = 'https://api.exemplo.com';
    final expectedUrl = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');

    final errorResponse = http.Response('{"error": "Dados inválidos"}', 400);

    when(() => mockClient.put(
      expectedUrl,
      headers: any(named: 'headers'),
      body: any(named: 'body'),
    )).thenAnswer((_) async => errorResponse);

    final response = await UsuarioService.alterarEmail(
      token: token,
      id: id,
      senhaAtual: senhaAtual,
      novoEmail: novoEmail,
      confirmacaoEmail: confirmacaoEmail,
      client: mockClient,
    );

    expect(response.statusCode, 400);
    expect(response.body, contains('Dados inválidos'));
  });
  test('Retorna http.Response com status 401 (não autorizado)', () async {
    final token = 'token_invalido';
    final id = '123';
    final senhaAtual = 'senhaAtual123';
    final novoEmail = 'novo@email.com';
    final confirmacaoEmail = 'novo@email.com';
    final baseUrl = 'https://api.exemplo.com';
    final expectedUrl = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');

    final unauthorizedResponse = http.Response('{"error": "Token inválido ou expirado"}', 401);

    when(() => mockClient.put(
      expectedUrl,
      headers: any(named: 'headers'),
      body: any(named: 'body'),
    )).thenAnswer((_) async => unauthorizedResponse);

    final response = await UsuarioService.alterarEmail(
      token: token,
      id: id,
      senhaAtual: senhaAtual,
      novoEmail: novoEmail,
      confirmacaoEmail: confirmacaoEmail,
      client: mockClient,
    );

    expect(response.statusCode, 401);
    expect(response.body, contains('Token inválido ou expirado'));
  });

  test('Verifica formato de headers e body na requisição', () async {
    final token = 'token_teste';
    final id = '123';
    final senhaAtual = 'senhaAtual123';
    final novoEmail = 'novo@email.com';
    final confirmacaoEmail = 'novo@email.com';
    final baseUrl = 'https://api.exemplo.com';
    final expectedUrl = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');

    final successResponse = http.Response('{"message": "Email alterado"}', 200);

    // Aqui capturamos os headers e body usados na chamada
    late Map<String, String> capturedHeaders;
    late String capturedBody;

    when(() => mockClient.put(
      expectedUrl,
      headers: captureAny(named: 'headers'),
      body: captureAny(named: 'body'),
    )).thenAnswer((invocation) async {
      capturedHeaders = invocation.namedArguments[const Symbol('headers')] as Map<String, String>;
      capturedBody = invocation.namedArguments[const Symbol('body')] as String;
      return successResponse;
    });

    final response = await UsuarioService.alterarEmail(
      token: token,
      id: id,
      senhaAtual: senhaAtual,
      novoEmail: novoEmail,
      confirmacaoEmail: confirmacaoEmail,
      client: mockClient,
    );

    // Verifica headers
    expect(capturedHeaders['Authorization'], 'Bearer $token');
    expect(capturedHeaders['Content-Type'], 'application/json');

    // Verifica body
    final bodyMap = jsonDecode(capturedBody) as Map<String, dynamic>;
    expect(bodyMap['senhaAtual'], senhaAtual);
    expect(bodyMap['novoEmail'], novoEmail);
    expect(bodyMap['confirmacaoEmail'], confirmacaoEmail);

    // Também checa a resposta
    expect(response.statusCode, 200);
    expect(response.body, contains('Email alterado'));
  });
}
