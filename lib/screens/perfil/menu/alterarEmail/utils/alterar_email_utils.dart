/// ALTERAR_EMAIL_UTILS
///
/// Responsável por: Funções utilitárias para alteração de e-mail, incluindo
/// correção de encoding, exibição de erros e tratamento de respostas da API.
/// Utilizado em: AlterarEmailController para processar respostas e exibir feedback.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

/// CORRIGIRENCODING
///
/// Descrição: Corrige problemas de encoding de caracteres especiais (acentuação)
/// que podem vir quebrados do backend.
/// Parâmetros:
/// - textoOriginal: Texto com possíveis problemas de encoding
/// Retorno: String com encoding corrigido ou original se falhar
///
/// Converte latin1 → utf8 para corrigir acentuação.
String corrigirEncoding(String textoOriginal) {
  try {
    // Converte de latin1 para utf8 para corrigir acentos
    return utf8.decode(latin1.encode(textoOriginal));
  } catch (_) {
    // Se falhar, retorna texto original
    return textoOriginal;
  }
}

/// EXIBIRERRO
///
/// Descrição: Exibe Flushbar de erro na parte superior da tela com mensagem corrigida.
/// Parâmetros:
/// - context: Contexto para exibir Flushbar
/// - mensagem: Mensagem de erro a ser exibida
/// - teste: Flag para testes (padrão: false)
/// Retorno: void
///
/// Aplica correção de encoding antes de exibir.
void exibirErro(BuildContext context, String mensagem, {bool teste = false}) {
  // Corrige encoding da mensagem antes de exibir
  final mensagemCorrigida = corrigirEncoding(mensagem);
  
  Flushbar(
    title: 'Verifique suas credenciais',           // Título fixo
    message: mensagemCorrigida,                    // Mensagem corrigida
    duration: const Duration(seconds: 5),         // Duração de 5 segundos
    backgroundColor: Colors.red.shade600,         // Fundo vermelho
    icon: const Icon(Icons.error_outline, color: Colors.white),  // Ícone de erro
    flushbarPosition: FlushbarPosition.TOP,       // Posição no topo
    borderRadius: BorderRadius.circular(10),      // Bordas arredondadas
    margin: const EdgeInsets.all(8),              // Margem externa
  ).show(context);
}

/// TRATARERRORESPOSTA
///
/// Descrição: Analisa resposta da API e exibe mensagens de erro específicas.
/// Parâmetros:
/// - context: Contexto para exibir erro
/// - response: Resposta HTTP da API
/// - teste: Flag para testes (padrão: false)
/// Retorno: void
///
/// Processa diferentes tipos de erro da API e exibe mensagens amigáveis.
void tratarErroResposta(BuildContext context, dynamic response, {bool teste = false}) {
  if (response.body.isNotEmpty) {
    try {
      // Tenta fazer parse do JSON da resposta
      final responseBody = jsonDecode(response.body);
      final errors = responseBody['errors'];

      // Verifica se há array de erros com mensagem
      if (errors is List && errors.isNotEmpty && errors[0]['message'] != null) {
        final mensagem = corrigirEncoding(errors[0]['message']);

        // Trata erros específicos com mensagens amigáveis
        if (mensagem.contains('Senha atual incorreta')) {
          exibirErro(context, 'A senha informada está incorreta.');
        } else if (mensagem.contains('E-mail já cadastrado')) {
          exibirErro(context, 'Este e-mail já está em uso. Tente outro.');
        } else {
          // Exibe mensagem original da API (corrigida)
          exibirErro(context, mensagem);
        }
      } else {
        // Estrutura de erro inesperada
        exibirErro(context, 'Erro ao alterar e-mail. Tente novamente.');
      }
    } catch (e) {
      // Erro no parse do JSON
      print('Erro no parse do JSON: $e\nResposta: ${response.body}');
      exibirErro(context, 'Erro inesperado. Tente novamente.');
    }
  } else {
    // Resposta sem corpo - usa status code
    exibirErro(context, 'Erro ao alterar e-mail. '
        'Status: ${response.statusCode}. ${response.reasonPhrase ?? ''}');
  }
}

// Fim do arquivo alterar_email_utils.dart
// 
// Funções utilitárias para alteração de e-mail:
// 
// 1. corrigirEncoding():
//    - Corrige problemas de acentuação do backend
//    - Conversão latin1 → utf8
//    - Fallback seguro se falhar
// 
// 2. exibirErro():
//    - Flushbar padronizado para erros
//    - Posição no topo, duração 5s
//    - Aplica correção de encoding
// 
// 3. tratarErroResposta():
//    - Parse inteligente de erros da API
//    - Mensagens específicas para erros comuns
//    - Fallback para erros inesperados
//    - Log para debug em caso de parse failure
