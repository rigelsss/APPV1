import 'dart:convert';
import 'package:http/http.dart' as http;

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

    final url = Uri.parse('http://10.0.2.2:9000/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': nome.trim(),
          'cpf': cpf.trim(),
          'email': email.trim(),
          'phone': telefone.trim(),
          'password': senha.trim(),
          'userType': 'MOBILE'
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      } else {
        print('Erro: ${response.statusCode}');
        print('Resposta: ${response.body}');
        return 'Erro ao cadastrar. Verifique os dados e tente novamente.';
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return 'Erro de conexão. Tente novamente.';
    }

  }
}
