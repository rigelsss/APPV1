import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:sudema_app/models/denuncia_data.dart';

class IdentificacaoController {
  String username = 'Acessar';
  String email = '';
  String? token;

  bool get isTokenValido {
    if (token == null || token!.isEmpty) return false;
    return !JwtDecoder.isExpired(token!);
  }

  Future<void> carregarDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null && savedToken.isNotEmpty) {
      token = savedToken;
      DenunciaData().tokenUsuario = token;

      try {
        final data = await AuthController.obterInformacoesUsuario(token!);

        if (data != null) {
          username = data['name'] ?? 'Usuário';
          email = data['email'] ?? 'email';
          DenunciaData().usuarioId = data['id'];
        }
      } catch (e) {
        print('Erro ao carregar informações do usuário: $e');
      }
    }
  }
}
