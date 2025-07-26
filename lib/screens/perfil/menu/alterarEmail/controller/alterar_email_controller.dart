/// ALTERAR_EMAIL_CONTROLLER
///
/// Responsável por: Lógica de negócio para alteração de e-mail, incluindo
/// autenticação JWT, comunicação com API e atualização de token.
/// Utilizado em: AlterarEmailForm para processar alteração de e-mail.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'package:sudema_app/services/AuthMe.dart';
import '../utils/alterar_email_utils.dart';

/// Classe AlterarEmailController
///
/// Descrição: Controller estático para alteração de e-mail com JWT e API.
class AlterarEmailController {
  /// CONFIRMARALTERACAO
  ///
  /// Descrição: Método principal para alteração de e-mail com fluxo completo:
  /// validação → decodificação JWT → requisição API → atualização token → navegação
  /// 
  /// Parâmetros:
  /// - context: Contexto para navegação e feedback visual
  /// - senhaAtual: Senha atual do usuário para validação de segurança
  /// - novoEmail: Novo endereço de e-mail desejado
  /// - confirmacaoEmail: Confirmação do novo e-mail (deve coincidir)
  /// 
  /// Retorno: Future<void>
  /// 
  /// Fluxo de execução:
  /// 1. Validação de autenticação (token existe)
  /// 2. Decodificação JWT para obter ID do usuário
  /// 3. Requisição PUT para API SUDEMA
  /// 4. Processamento da resposta (sucesso/erro)
  /// 5. Atualização do token local (se sucesso)
  /// 6. Navegação para home (se sucesso)
  static Future<void> confirmarAlteracao({
    required BuildContext context,
    required String senhaAtual,
    required String novoEmail,
    required String confirmacaoEmail,
  }) async {
    // Etapa 1: Obtenção e validação do token de autenticação
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Validação crítica: usuário deve estar autenticado
    if (token == null) {
      exibirErro(context, 'Usuário não autenticado.');
      return; // Interrompe execução se não autenticado
    }

    // Etapa 2: Decodificação do JWT para extrair informações do usuário
    final decodedToken = JwtDecoder.decode(token);  // Decodifica payload do JWT
    final id = decodedToken['id'];                  // Extrai ID do usuário
    
    // Etapa 3: Preparação da requisição para API
    final baseUrl = dotenv.env['URL_API'];          // URL base do arquivo .env
    final url = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');  // Endpoint específico

    // Etapa 4: Execução da requisição HTTP PUT para API SUDEMA
    /// 
    /// Integração com API SUDEMA:
    /// Endpoint: PUT /usuarios/mobile/{id}/alterar-email
    /// Autenticação: Bearer Token (JWT)
    /// Payload: senha atual + novo e-mail + confirmação
    /// 
    /// A API valida:
    /// - Token JWT válido e não expirado
    /// - Senha atual correta
    /// - Novo e-mail não já cadastrado no sistema
    /// - Coincidência entre novoEmail e confirmacaoEmail
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',     // Indica payload JSON
        'Authorization': 'Bearer $token',       // Autenticação JWT
      },
      body: jsonEncode({
        "senhaAtual": senhaAtual.trim(),         // Senha para validação (sem espaços)
        "novoEmail": novoEmail.trim(),           // Novo e-mail (sem espaços)
        "confirmacaoEmail": confirmacaoEmail.trim(),  // Confirmação (sem espaços)
      }),
    );

    // Etapa 5: Processamento da resposta da API
    if (response.statusCode == 200) {
      // Sucesso: API retornou status 200 (OK)
      try {
        // Parse do JSON de resposta
        final responseBody = jsonDecode(response.body);
        final novoToken = responseBody['token'];  // Extrai novo token JWT

        // Validação do novo token recebido
        if (novoToken != null && novoToken is String) {
          // Etapa 6: Atualização do token local
          /// 
          /// Por que um novo token?
          /// Quando o e-mail é alterado, o JWT precisa ser atualizado pois:
          /// - O payload do token contém informações do usuário (incluindo e-mail)
          /// - Token antigo fica inválido após alteração
          /// - Novo token reflete o estado atualizado do usuário
          await AuthController.updateToken(novoToken);  // Salva novo token localmente
          
          // Etapa 7: Feedback visual de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-mail alterado com sucesso!')),
          );
          
          // Etapa 8: Navegação para home com limpeza de stack
          /// 
          /// pushNamedAndRemoveUntil com (route) => false:
          /// - Remove todas as rotas anteriores da pilha
          /// - Impede volta para tela de alteração após sucesso
          /// - Garante que home seja a nova raiz da navegação
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          // Token não recebido ou formato inválido
          exibirErro(context, 'Token não recebido. Tente novamente.');
        }
      } catch (_) {
        // Erro no parse do JSON de resposta
        exibirErro(context, 'Erro ao processar resposta do servidor.');
      }
    } else {
      // Erro: API retornou status diferente de 200
      /// 
      /// tratarErroResposta() processa:
      /// - Status 400: Dados inválidos (senha incorreta, e-mail já existe)
      /// - Status 401: Token inválido ou expirado
      /// - Status 500: Erro interno do servidor
      /// - Outros: Erros inesperados
      tratarErroResposta(context, response);
    }
  }

  // Fim da classe AlterarEmailController
  // 
  // Controller completo para alteração de e-mail com:
  // 
  // 🔒 SEGURANÇA:
  // - Validação de autenticação via JWT
  // - Decodificação segura do token
  // - Validação de senha atual na API
  // - Trim automático para evitar espaços
  // 
  // 🌐 INTEGRAÇÃO API:
  // - Endpoint PUT específico para alteração
  // - Headers de autenticação e content-type
  // - Payload estruturado com validações
  // - URL dinâmica via variáveis de ambiente
  // 
  // 🔄 GERENCIAMENTO DE TOKEN:
  // - Atualização automática após alteração
  // - Persistência local via AuthController
  // - Invalidação do token anterior
  // - Sincronização com estado da sessão
  // 
  // 📱 UX/UI:
  // - Feedback visual via SnackBar
  // - Tratamento de erros específicos
  // - Navegação com limpeza de stack
  // - Mensagens amigáveis ao usuário
  // 
  // ⚙️ TRATAMENTO DE ERROS:
  // - Parse seguro de JSON
  // - Validação de tipos de dados
  // - Fallback para erros inesperados
  // - Utilização de utils especializadas
  // 
  // 📦 DEPENDÊNCIAS:
  // - SharedPreferences: persistência de token
  // - JWT Decoder: decodificação de token
  // - HTTP: requisições para API
  // - Flutter Dotenv: variáveis de ambiente
  // - AuthController: gerenciamento de autenticação
  // - Utils: tratamento de erros e feedback
}
