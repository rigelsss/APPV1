import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'package:sudema_app/services/AuthMe.dart';
import '../utils/alterar_email_utils.dart';

class AlterarEmailController {
  static Future<void> confirmarAlteracao({
    required BuildContext context,
    required String senhaAtual,
    required String novoEmail,
    required String confirmacaoEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      exibirErro(context, 'Usuário não autenticado.');
      return;
    }

    final decodedToken = JwtDecoder.decode(token);
    final id = decodedToken['id'];
    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "senhaAtual": senhaAtual.trim(),
        "novoEmail": novoEmail.trim(),
        "confirmacaoEmail": confirmacaoEmail.trim(),
      }),
    );

    if (response.statusCode == 200) {
      try {
        final responseBody = jsonDecode(response.body);
        final novoToken = responseBody['token'];

        if (novoToken != null && novoToken is String) {
          await AuthController.updateToken(novoToken);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-mail alterado com sucesso!')),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          exibirErro(context, 'Token não recebido. Tente novamente.');
        }
      } catch (_) {
        exibirErro(context, 'Erro ao processar resposta do servidor.');
      }
    } else {
      tratarErroResposta(context, response);
    }
  }
}
