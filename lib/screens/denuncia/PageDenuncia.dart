/// PAGE_DENUNCIA
///
/// Responsável por: Exibir a tela inicial do módulo de denúncias ambientais da SUDEMA.
/// Utilizado em: Aba "Denúncias" da navegação principal do aplicativo.
/// 
/// Esta tela apresenta informações educativas sobre denúncias ambientais,
/// incluindo orientações sobre o que constitui infração ambiental e
/// o processo após a denúncia. Contém:
/// - Botão principal para iniciar nova denúncia
/// - Informações sobre importância das denúncias
/// - Link para decreto estadual sobre infrações ambientais

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../diversos/webview_screen.dart';
import 'denunciawraprellerscreen.dart';

class DenunciaPage extends StatelessWidget {
  const DenunciaPage({super.key});

  /// Widget DenunciaPage
  ///
  /// Descrição: Interface inicial do módulo de denúncias com informações educativas.
  /// Contém botão de ação principal e conteúdo informativo sobre denúncias ambientais.
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600; // Detecta se é tablet para layout responsivo

    // Estilos de texto padronizados para a tela
    final tituloStyle = GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w700, // Negrito para títulos das seções
    );
    final textoStyle = GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w300, // Texto normal para conteúdo
    );
    final botaoStyle = GoogleFonts.lato(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white, // Texto branco para botão principal
    );
    final linkStyle = GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF2A2F8C), // Azul institucional da SUDEMA
      decoration: TextDecoration.underline, // Sublinhado para indicar link
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da seção sempre alinhado à esquerda
              Text(
                'Denúncias',
                style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),

              // Conteúdo principal com layout responsivo
              // Centralizado em tablets, largura total em celulares
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botão principal para iniciar nova denúncia
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navega para o fluxo completo de denúncia
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DenunciaWrapperScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A2F8C), // Azul institucional SUDEMA
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Realizar denúncia', style: botaoStyle),
                              const SizedBox(width: 10),
                              // Ícone de denúncia ao lado do texto
                              Image.asset(
                                'assets/icon/img_1.png',
                                width: 28,
                                height: 28,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Seção educativa: Importância das denúncias
                      Text('Por que denunciar?', style: tituloStyle),
                      const SizedBox(height: 12),
                      Text(
                        'Denunciar infrações ambientais é um ato de cidadania que contribui para a preservação do meio ambiente e para a redução dos impactos negativos na natureza. As denúncias permitem que os órgãos competentes tomem conhecimento de irregularidades ambientais e que medidas sejam adotadas para minimizar ou reverter os danos causados.',
                        style: textoStyle,
                      ),
                      const SizedBox(height: 12),
                      
                      // Seção educativa: Processo após denúncia
                      Text('O que acontece após a denúncia?', style: tituloStyle),
                      const SizedBox(height: 12),
                      Text(
                        'A denúncia é analisada e, caso as infrações sejam confirmadas, um processo é instaurado. Dependendo da gravidade da infração, o caso pode ser encaminhado para julgamento em âmbito estadual ou federal.',
                        style: textoStyle,
                      ),
                      const SizedBox(height: 12),
                      
                      // Seção educativa: Definição de infrações ambientais
                      Text('O que é considerado infração ambiental?', style: tituloStyle),
                      const SizedBox(height: 12),
                      Text(
                        'Foi publicado, em março de 2024, no Diário Oficial do Estado da Paraíba, o Decreto Estadual n° 44.889/2024, que trata das infrações ambientais, do processo administrativo para sua apuração e suas respectivas sanções.',
                        style: textoStyle,
                      ),
                      const SizedBox(height: 24),
                      
                      // Link para visualizar o decreto estadual em WebView
                      GestureDetector(
                        onTap: () {
                          // Abre o decreto em WebView para consulta
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewScreen(
                                url: 'https://drive.google.com/file/d/1Bb3IhBcoZLN2FkPm_vzzkhkvhBMT7BQ_/view',
                              ),
                            ),
                          );
                        },
                        // Container estilizado como botão de link
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5), // Fundo cinza claro
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF2A2F8C)), // Borda azul SUDEMA
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown, // Ajusta texto se necessário
                            child: Text(
                              'Decreto Estadual nº 44.889, de 26 de março de 2024',
                              style: linkStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
