import 'package:flutter/material.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class IdentificacaoController {
  bool logado = false;
  bool anonimo = false;
  String? usuarioEmail;

  void verificarLogin(VoidCallback onUpdate) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      final dadosUsuario = await AuthController.obterInformacoesUsuario(token);
      if (dadosUsuario != null && dadosUsuario['email'] != null) {
        logado = true;
        usuarioEmail = dadosUsuario['email'];
        anonimo = false;
        DenunciaData().usuarioEmail = usuarioEmail;
      }
    }

    onUpdate();
  }

  void selecionarAnonimo() {
    anonimo = true;
    DenunciaData().anonimo = true;
    DenunciaData().identificacaoConfirmada = false;
  }

  void selecionarIdentificado() {
    anonimo = false;
    DenunciaData().anonimo = false;
    DenunciaData().identificacaoConfirmada = true;
  }

  Widget titulo() {
    return Text(
      'Identificação',
      style: GoogleFonts.lato(
          fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}
