/// IDENTIFICACAO_MENSAGEM
///
/// Responsável por: Widget de mensagem para usuários não autenticados.
/// Utilizado em: Etapa de identificação quando usuário não está logado.
/// 
/// Este widget contém:
/// - Mensagem explicativa sobre necessidade de login
/// - Informação sobre opção de denúncia anônima após login
/// - Botão para navegar para tela de login
/// - Layout responsivo para tablets e celulares
/// - Alinhamento centralizado em tablets

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdentificacaoMensagem extends StatelessWidget {
  final VoidCallback onLogin; // Callback para navegar para login

  const IdentificacaoMensagem({super.key, required this.onLogin});

  /// Widget IdentificacaoMensagem
  ///
  /// Descrição: Interface para usuários não logados com mensagem e botão de login.
  /// Layout responsivo com alinhamento diferente para tablets.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;

        final Widget conteudo = Column(
          // Alinhamento dinâmico baseado no tipo de dispositivo
          crossAxisAlignment:
          isTablet ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            // Mensagem explicativa sobre necessidade de login
            Text(
              'É necessário acessar o sistema para realizar uma denúncia. Após o login você pode escolher fazer a denúncia de forma anônima.',
              style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w300),
              textAlign: isTablet ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 40),
            
            // Botão para navegar para login
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onLogin, // Navega para tela de login
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C), // Azul SUDEMA
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Acessar o sistema',
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        );

        // Layout responsivo: centraliza e limita largura em tablets
        if (isTablet) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: conteudo,
            ),
          );
        }

        // Layout normal para celulares
        return conteudo;
      },
    );
  }
}
