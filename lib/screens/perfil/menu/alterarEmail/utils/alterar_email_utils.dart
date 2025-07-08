import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

/// Corrige problemas de encoding de caracteres (acentuação quebrada vinda do backend)
String corrigirEncoding(String textoOriginal) {
  try {
    return utf8.decode(latin1.encode(textoOriginal));
  } catch (_) {
    return textoOriginal;
  }
}

/// Exibe um flushbar de erro na parte superior da tela
void exibirErro(BuildContext context, String mensagem) {
  final mensagemCorrigida = corrigirEncoding(mensagem);
  Flushbar(
    title: 'Verifique suas credenciais',
    message: mensagemCorrigida,
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.red.shade600,
    icon: const Icon(Icons.error_outline, color: Colors.white),
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(10),
    margin: const EdgeInsets.all(8),
  ).show(context);
}

/// Analisa o body da resposta e exibe mensagens de erro específicas
void tratarErroResposta(BuildContext context, dynamic response) {
  if (response.body.isNotEmpty) {
    try {
      final responseBody = jsonDecode(response.body);
      final errors = responseBody['errors'];

      if (errors is List && errors.isNotEmpty && errors[0]['message'] != null) {
        final mensagem = corrigirEncoding(errors[0]['message']);

        if (mensagem.contains('Senha atual incorreta')) {
          exibirErro(context, 'A senha informada está incorreta.');
        } else if (mensagem.contains('E-mail já cadastrado')) {
          exibirErro(context, 'Este e-mail já está em uso. Tente outro.');
        } else {
          exibirErro(context, mensagem);
        }
      } else {
        exibirErro(context, 'Erro ao alterar e-mail. Tente novamente.');
      }
    } catch (e) {
      print('Erro no parse do JSON: $e\nResposta: ${response.body}');
      exibirErro(context, 'Erro inesperado. Tente novamente.');
    }
  } else {
    exibirErro(context, 'Erro ao alterar e-mail. '
        'Status: ${response.statusCode}. ${response.reasonPhrase ?? ''}');
  }
}
