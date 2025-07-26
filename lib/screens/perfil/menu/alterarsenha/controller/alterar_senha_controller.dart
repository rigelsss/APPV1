/// ALTERAR_SENHA_CONTROLLER
///
/// Responsável por: Lógica de negócio para alteração de senha, incluindo
/// validações, obtenção de token e comunicação com service.
/// Utilizado em: AlterarSenhaForm para processar alteração de senha.

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/services/AuthMe.dart';
import '../service/alterar_senha_service.dart';

/// Classe AlterarSenhaController
///
/// Descrição: Controller estático com método principal para alterar senha
/// com validações e integração com services.
class AlterarSenhaController {
  /// ALTERARSENHA
  ///
  /// Descrição: Método principal para alterar senha com validações e chamada de service.
  /// Parâmetros:
  /// - senhaAtual: Senha atual do usuário para validação
  /// - novaSenha: Nova senha desejada
  /// - confirmarSenha: Confirmação da nova senha
  /// Retorno: Future<String?> - null se sucesso, mensagem de erro se falhar
  static Future<String?> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
    required String confirmarSenha,
  }) async {
    // Validação 1: Senhas novas devem coincidir
    if (novaSenha != confirmarSenha) {
      return 'As senhas novas não coincidem';
    }

    // Obtenção do token de autenticação
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Validação 2: Token deve existir
    if (token == null) {
      return 'Token não encontrado. Faça login novamente.';
    }

    try {
      // Obtém informações do usuário para extrair ID
      final userInfo = await AuthController.obterInformacoesUsuario(token);
      final userId = userInfo?['id'];

      // Validação 3: ID do usuário deve existir
      if (userId == null) {
        return 'ID de usuário não encontrado.';
      }

      // Chama service para alterar senha na API
      final resultado = await UsuarioController.alterarSenha(
        userId: userId,
        senhaAtual: senhaAtual,
        novaSenha: novaSenha,
      );

      return resultado;  // null se sucesso, mensagem se erro
    } catch (e) {
      // Tratamento de exceções gerais
      return 'Ocorreu um erro ao tentar alterar a senha: $e';
    }
  }

  // Fim da classe AlterarSenhaController
  // 
  // Controller para alteração de senha com:
  // - Validação de coincidência de senhas
  // - Obtenção de token do SharedPreferences
  // - Busca de ID do usuário via AuthController
  // - Chamada do service de alteração
  // - Tratamento de erros com mensagens específicas
}
