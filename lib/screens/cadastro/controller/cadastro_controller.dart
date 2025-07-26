/// CADASTRO_CONTROLLER
///
/// Responsável por: Gerenciar lógica de cadastro de usuários, incluindo validação
/// de dados e comunicação com a API de registro da SUDEMA.
/// Utilizado em: Formulário de cadastro para processar dados e criar contas.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegistroController {
  /// VALIDAREREGISTRAR
  ///
  /// Descrição: Valida dados do formulário e registra novo usuário na API da SUDEMA.
  /// Parâmetros:
  /// - nome: Nome completo do usuário
  /// - cpf: CPF formatado e validado
  /// - telefone: Telefone com máscara
  /// - email: E-mail para autenticação
  /// - senha: Senha segura
  /// - aceitouTermos: Confirmação de aceite dos termos
  /// Retorno: Future<String?> - null se sucesso, mensagem de erro se falhar
  Future<String?> validarERegistrar({
    required String nome,
    required String cpf,
    required String telefone,
    required String email,
    required String senha,
    required bool aceitouTermos,
  }) async {
    // Validação 1: Campos obrigatórios
    if (nome.trim().isEmpty ||
        cpf.trim().isEmpty ||
        telefone.trim().isEmpty ||
        email.trim().isEmpty ||
        senha.trim().isEmpty) {
      return 'Todos os campos são obrigatórios.';
    }

    // Validação 2: Aceite dos termos
    if (!aceitouTermos) {
      return 'Você precisa aceitar os termos para continuar.';
    }

    // Configuração da requisição HTTP
    final baseUrl = dotenv.env['URL_API'] ?? '';
    final url = Uri.parse('$baseUrl/auth/register'); // Endpoint de registro

    try {
      /// Integração com a API de registro
      ///
      /// Envia dados do usuário para o endpoint:
      /// POST /auth/register
      ///
      /// Requer dados completos e userType 'MOBILE'.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome.trim(),                    // Nome completo sem espaços extras
          'cpf': cpf.trim(),                      // CPF sem máscara
          'email': email.trim(),                  // E-mail para autenticação
          'telefone': telefone.trim(),            // Telefone sem máscara
          'senha': senha.trim(),                  // Senha segura
          'senhaConfirmacao': senha.trim(),       // Confirmação de senha
          'userType': 'MOBILE'                    // Tipo de usuário (app mobile)
        }),
      );

      // Logs para debug (remover em produção)
      print('Status: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      // Processamento da resposta da API
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sucesso: cadastro realizado com sucesso
        /* Código comentado - envio automático de código desabilitado
        final envioCodigoErro = await enviarCodigoConfirmacao(email);
        if (envioCodigoErro != null) {
          return envioCodigoErro;
        } */
        return null; // Retorna null indicando sucesso
      } else if (response.statusCode == 400) {
        // Erro de validação: extrai mensagem específica da API
        final body = json.decode(utf8.decode(response.bodyBytes));
        if (body['errors'] != null && body['errors'] is List && body['errors'].isNotEmpty) {
          // Extrai primeira mensagem de erro da lista
          final mensagemErro = body['errors'][0]['message']?.toString() ?? 'Erro desconhecido';
          return mensagemErro;
        }
        return 'Erro na solicitação. verifique os dados';
      }
    } catch (e) {
      // Tratamento de erros de conexão/rede
      print('Erro de conexão: $e');
      return 'Erro de conexão. Tente novamente.';
    }
  }

  /// ENVIARCODIGOCONFIRMACAO
  ///
  /// Descrição: Solicita envio de código de confirmação para o e-mail do usuário.
  /// Parâmetros:
  /// - email: E-mail do usuário para receber o código
  /// Retorno: Future<String?> - null se sucesso, mensagem de erro se falhar
  ///
  /// Método auxiliar usado após cadastro bem-sucedido.
  Future<String?> enviarCodigoConfirmacao(String email) async {
    // Configuração da requisição HTTP
    final baseUrl = dotenv.env['URL_API'] ?? '';
    final url = Uri.parse('$baseUrl/auth/register/resend-confirm'); // Endpoint de reenvio

    try {
      /// Integração com a API de reenvio de código
      ///
      /// Envia solicitação para o endpoint:
      /// POST /auth/register/resend-confirm
      ///
      /// Requer e-mail e userType 'MOBILE'.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email.trim(),    // E-mail do usuário
          'userType': 'MOBILE',     // Tipo de usuário (app mobile)
        }),
      );

      // Processamento da resposta da API
      if (response.statusCode == 200 || response.statusCode == 204) {
        return null; // Sucesso: código enviado
      } else {
        // Erro: log para debug e retorna mensagem genérica
        print('Erro ao enviar código: ${response.statusCode}');
        print('Resposta: ${response.body}');
        return 'Erro ao enviar código de confirmação.';
      }
    } catch (e) {
      // Tratamento de erros de conexão/rede
      print('Erro de conexão no envio do código: $e');
      return 'Erro de conexão. Tente novamente.';
    }
  }

  // Fim da classe RegistroController
  // Métodos disponíveis:
  // - validarERegistrar(): Cadastro completo com validações
  // - enviarCodigoConfirmacao(): Reenvio de código de verificação
}
