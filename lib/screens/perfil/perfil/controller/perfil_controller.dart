/// PERFIL_CONTROLLER
///
/// Responsável por: Gerenciar estado e dados do perfil do usuário, incluindo
/// carregamento de informações da API, tratamento de erros e logout.
/// Utilizado em: PerfilPage como controller principal para gerenciar dados.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/services/AuthMe.dart';

/// Classe PerfilController
///
/// Descrição: ChangeNotifier que gerencia estado do perfil com padrão observer
/// para notificar widgets sobre mudanças nos dados.
class PerfilController extends ChangeNotifier {
  // Dados do usuário carregados da API
  Map<String, dynamic> userData = {};
  
  // Estados de controle
  bool isLoading = true;        // Estado de carregamento
  bool errorFetching = false;   // Estado de erro
  String errorMessage = '';     // Mensagem de erro específica
  
  // Token JWT para autenticação
  late String token;

  /// PREPARARTOKEN
  ///
  /// Descrição: Configura token de autenticação e inicia carregamento de dados.
  /// Parâmetros:
  /// - tokenExterno: Token opcional passado externamente
  /// Retorno: Future<void>
  ///
  /// Prioriza token externo, senão busca token salvo localmente.
  Future<void> prepararToken({String? tokenExterno}) async {
    if (tokenExterno != null && tokenExterno.isNotEmpty) {
      // Caso 1: Token fornecido externamente
      token = tokenExterno;
      await carregarDadosUsuario();  // Carrega dados imediatamente
    } else {
      // Caso 2: Busca token salvo localmente
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');

      if (savedToken != null && savedToken.isNotEmpty) {
        // Token encontrado localmente
        token = savedToken;
        await carregarDadosUsuario();  // Carrega dados
      } else {
        // Caso 3: Nenhum token disponível
        errorFetching = true;
        isLoading = false;
        errorMessage = 'Token inválido ou não fornecido.';
        notifyListeners();  // Notifica widgets sobre erro
      }
    }
  }

  /// CARREGARDADOSUSUARIO
  ///
  /// Descrição: Carrega dados do usuário da API usando token de autenticação.
  /// Parâmetros: nenhum (usa token da classe)
  /// Retorno: Future<void>
  ///
  /// Atualiza userData e estados de loading/erro, notificando listeners.
  Future<void> carregarDadosUsuario() async {
    try {
      // Chama service de autenticação para obter dados
      final data = await AuthController.obterInformacoesUsuario(token);

      if (data != null) {
        // Sucesso: atualiza dados e finaliza loading
        userData = data;
        isLoading = false;
        notifyListeners();  // Notifica widgets sobre sucesso
      } else {
        // API retornou null
        errorFetching = true;
        isLoading = false;
        errorMessage = 'Informações do usuário não encontradas.';
        notifyListeners();  // Notifica widgets sobre erro
      }
    } catch (e) {
      // Erro na requisição ou parsing
      errorFetching = true;
      isLoading = false;
      errorMessage = 'Erro ao buscar dados: $e';
      notifyListeners();  // Notifica widgets sobre erro
    }
  }

  /// LOGOUT
  ///
  /// Descrição: Realiza logout removendo token salvo e navegando para home.
  /// Parâmetros:
  /// - context: Contexto para navegação
  /// Retorno: Future<void>
  ///
  /// Remove token do SharedPreferences e navega para home limpando stack.
  Future<void> logout(BuildContext context) async {
    // Remove token salvo localmente
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Verifica se contexto ainda é válido antes de navegar
    if (!context.mounted) return;
    
    // Navega para home removendo todas as rotas anteriores
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  // Fim da classe PerfilController
  // 
  // Controller de perfil com:
  // - Gerenciamento de estado via ChangeNotifier
  // - Carregamento de dados do usuário via API
  // - Tratamento de erros com mensagens específicas
  // - Suporte a token externo ou salvo localmente
  // - Logout com limpeza de dados e navegação
}