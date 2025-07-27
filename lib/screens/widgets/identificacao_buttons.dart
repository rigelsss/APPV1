/// IDENTIFICACAO_BUTTONS
///
/// Responsável por: Botões condicionais para escolha entre denúncia identificada,
/// anônima ou login, baseado no estado de autenticação.
/// Utilizado em: Sistema de denúncias na etapa de identificação.

import 'package:flutter/material.dart';
import 'package:sudema_app/models/denuncia_data.dart';

/// Widget IdentificacaoButtons
///
/// Descrição: Botões adaptativos que mudam baseado no estado de login,
/// permitindo escolha entre denúncia identificada ou anônima.
class IdentificacaoButtons extends StatelessWidget {
  final bool isLoggedIn;        // Se usuário está logado
  final String email;           // E-mail do usuário logado
  final VoidCallback onProsseguir; // Callback para prosseguir no fluxo

  const IdentificacaoButtons({
    super.key,
    required this.isLoggedIn,
    required this.email,
    required this.onProsseguir,
  });

  /// BUILD
  ///
  /// Descrição: Constrói interface condicional baseada no estado de login.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Column (logado) ou ElevatedButton (não logado)
  @override
  Widget build(BuildContext context) {
    // Estado: Usuário logado - exibe opções de identificação
    if (isLoggedIn) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Exibe e-mail do usuário logado
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Você acessou o sistema como: ',
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: email,  // E-mail em destaque
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Botão 1: Denúncia identificada (primário)
          ElevatedButton.icon(
            onPressed: () {
              DenunciaData().anonimo = false;  // Define como identificada
              onProsseguir();                  // Prossegue no fluxo
            },
            label: const Text(
              'Prosseguir com Identificação',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2A2F8C),  // Azul SUDEMA
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 128),
            ),
          ),
          const SizedBox(height: 16),
          
          // Botão 2: Denúncia anônima (secundário)
          ElevatedButton.icon(
            onPressed: () {
              DenunciaData().anonimo = true;  // Define como anônima
              onProsseguir();                 // Prossegue no fluxo
            },
            label: const Text(
              'Prosseguir Anônimo',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,  // Fundo branco
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Color(0xFF2A2F8C)),  // Borda azul
              ),
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 128),
            ),
          ),
        ],
      );
    } else {
      // Estado: Usuário não logado - exibe botão de login
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/login');  // Navega para tela de login
        },
        label: const Text(
          'Acessar Sistema',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2A2F8C),  // Azul SUDEMA
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 128),
        ),
      );
    }
  }

  // Fim da classe IdentificacaoButtons
  // 
  // Botões condicionais com:
  // 
  // 🔐 ESTADO LOGADO:
  // - Exibição do e-mail do usuário
  // - Botão primário: "Prosseguir com Identificação"
  // - Botão secundário: "Prosseguir Anônimo"
  // - Integração com DenunciaData singleton
  // 
  // 🚪 ESTADO NÃO LOGADO:
  // - Botão único: "Acessar Sistema"
  // - Navegação para tela de login
  // - Estilo consistente com tema
  // 
  // 🎨 DESIGN:
  // - Cores institucionais SUDEMA
  // - Bordas arredondadas (20px)
  // - Padding generoso para toque
  // - Hierarquia visual clara
  // 
  // 📊 FLUXO:
  // - Define DenunciaData().anonimo baseado na escolha
  // - Callback onProsseguir() para continuar fluxo
  // - Navegação condicional para login
}
