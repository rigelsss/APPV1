/// IDENTIFICACAO_CONTROLLER
///
/// Responsável por: Gerenciar estado e lógica da etapa de identificação de denúncias.
/// Utilizado em: Controle da primeira etapa do fluxo de denúncias (escolha de identificação).
/// 
/// Este controller gerencia:
/// - Verificação de autenticação do usuário
/// - Validação de token JWT
/// - Escolha entre denúncia anônima ou identificada
/// - Integração com modelo global DenunciaData
/// - Obtenção de dados do usuário logado

import 'package:flutter/material.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class IdentificacaoController {
  // Estados de autenticação e identificação
  bool logado = false;        // Se usuário está autenticado
  bool anonimo = false;       // Se escolheu denúncia anônima
  String? usuarioEmail;       // Email do usuário logado

  /// verificarLogin
  ///
  /// Descrição: Verifica se usuário está autenticado com token válido.
  /// Parâmetros:
  /// - onUpdate: callback para atualizar interface após verificação
  /// Retorno: void
  ///
  /// Valida token JWT e obtém dados do usuário se autenticado.
  void verificarLogin(VoidCallback onUpdate) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Verifica se token existe e não está expirado
    if (token != null && !JwtDecoder.isExpired(token)) {
      // Obtém informações do usuário a partir do token
      final dadosUsuario = await AuthController.obterInformacoesUsuario(token);
      if (dadosUsuario != null && dadosUsuario['email'] != null) {
        logado = true;
        usuarioEmail = dadosUsuario['email'];
        anonimo = false;
        // Salva email no modelo global
        DenunciaData().usuarioEmail = usuarioEmail;
      }
    }

    // Atualiza interface após verificação
    onUpdate();
  }

  /// selecionarAnonimo
  ///
  /// Descrição: Configura denúncia como anônima no modelo global.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Denúncia anônima não vincula dados do usuário ao envio.
  void selecionarAnonimo() {
    anonimo = true;
    DenunciaData().anonimo = true;
    DenunciaData().identificacaoConfirmada = false; // Anônima não confirma identificação
  }

  /// selecionarIdentificado
  ///
  /// Descrição: Configura denúncia como identificada no modelo global.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Denúncia identificada vincula dados do usuário logado ao envio.
  void selecionarIdentificado() {
    anonimo = false;
    DenunciaData().anonimo = false;
    DenunciaData().identificacaoConfirmada = true; // Confirma identificação
  }

  /// titulo
  ///
  /// Descrição: Cria widget de título padronizado para a etapa.
  /// Parâmetros: nenhum
  /// Retorno: Widget - texto estilizado
  Widget titulo() {
    return Text(
      'Identificação',
      style: GoogleFonts.lato(
          fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}
