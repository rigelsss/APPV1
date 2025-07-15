import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/services/AuthMe.dart';
import '../service/alterar_senha_service.dart';

class AlterarSenhaController {
  static Future<String?> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
    required String confirmarSenha,
  }) async {
    if (novaSenha != confirmarSenha) {
      return 'As senhas novas não coincidem';
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return 'Token não encontrado. Faça login novamente.';
    }

    try {
      final userInfo = await AuthController.obterInformacoesUsuario(token);
      final userId = userInfo?['id'];

      if (userId == null) {
        return 'ID de usuário não encontrado.';
      }

      final resultado = await UsuarioController.alterarSenha(
        userId: userId,
        senhaAtual: senhaAtual,
        novaSenha: novaSenha,
      );

      return resultado;
    } catch (e) {
      return 'Ocorreu um erro ao tentar alterar a senha: $e';
    }
  }
}
