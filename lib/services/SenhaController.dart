import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioController {
  static Future<String?> alterarSenha({
    required String userId,
    required String senhaAtual,
    required String novaSenha,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return 'Token não encontrado';

    final url = 'http://10.0.2.2:9000/api/v1/usuarios/mobile/$userId/alterar-senha';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'senhaAtual': senhaAtual,
          'novaSenha': novaSenha,
          'confirmacaoNovaSenha': novaSenha,
        }),
      );

      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 204) {
        print('Nenhum conteúdo para processar.');
        return null;
      }

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          print('Senha alterada com sucesso: ${response.body}');
          return null;
        } else {
          print('Corpo da resposta vazio.');
          return 'Erro ao alterar a senha';
        }
      } else {
        return jsonDecode(response.body)['message'] ?? 'Erro ao alterar a senha';
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return 'Erro ao conectar com o servidor';
    }
  }
}
