import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegistroController {
  Future<String?> validarERegistrar({
    required String nome,
    required String cpf,
    required String telefone,
    required String email,
    required String senha,
    required bool aceitouTermos,
  }) async {
    if (nome.trim().isEmpty ||
        cpf.trim().isEmpty ||
        telefone.trim().isEmpty ||
        email.trim().isEmpty ||
        senha.trim().isEmpty) {
      return 'Todos os campos são obrigatórios.';
    }

    if (!aceitouTermos) {
      return 'Você precisa aceitar os termos para continuar.';
    }

    final baseUrl = dotenv.env['URL_API'] ?? '';
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome.trim(),
          'cpf': cpf.trim(),
          'email': email.trim(),
          'telefone': telefone.trim(),
          'senha': senha.trim(),
          'senhaConfirmacao': senha.trim(),
          'userType': 'MOBILE'
        }),
      );

      print('Status: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        /* final envioCodigoErro = await enviarCodigoConfirmacao(email);
        if (envioCodigoErro != null) {
          return envioCodigoErro;
        } */
        return null;
      } else if (response.statusCode == 400) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        if (body['errors'] != null && body['errors'] is List && body['errors'].isNotEmpty) {
          final mensagemErro = body['errors'][0]['message']?.toString() ?? 'Erro desconhecido';
          return mensagemErro;
        }
        return 'Erro na solicitação. verifique os dados';
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return 'Erro de conexão. Tente novamente.';
    }
  }

  Future<String?> enviarCodigoConfirmacao(String email) async {
    final baseUrl = dotenv.env['URL_API'] ?? '';
    final url = Uri.parse('$baseUrl/auth/register/resend-confirm');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email.trim(),
          'userType': 'MOBILE',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return null;
      } else {
        print('Erro ao enviar código: ${response.statusCode}');
        print('Resposta: ${response.body}');
        return 'Erro ao enviar código de confirmação.';
      }
    } catch (e) {
      print('Erro de conexão no envio do código: $e');
      return 'Erro de conexão. Tente novamente.';
    }
  }
}
