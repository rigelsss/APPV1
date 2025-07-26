/// IDENTIFICACAO_BOTOES
///
/// Responsável por: Widget com botões de escolha entre denúncia anônima ou identificada.
/// Utilizado em: Etapa de identificação quando usuário está logado.
/// 
/// Este widget contém:
/// - Mensagem mostrando email do usuário logado
/// - Botão para denúncia identificada (com dados do usuário)
/// - Botão para denúncia anônima (sem vincular usuário)
/// - Estados visuais diferentes baseado na seleção
/// - Layout responsivo para tablets e celulares

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdentificacaoBotoes extends StatelessWidget {
  final VoidCallback onSelecionarAnonimo;      // Callback para denúncia anônima
  final VoidCallback onSelecionarIdentificado; // Callback para denúncia identificada
  final bool anonimo;                          // Estado atual da seleção
  final String? usuarioEmail;                  // Email do usuário logado

  const IdentificacaoBotoes({
    super.key,
    required this.onSelecionarAnonimo,
    required this.onSelecionarIdentificado,
    required this.anonimo,
    required this.usuarioEmail,
  });

  /// Widget IdentificacaoBotoes
  ///
  /// Descrição: Interface de escolha entre denúncia anônima ou identificada.
  /// Layout responsivo com botões que mudam de estado visual.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;

        final Widget conteudo = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mensagem mostrando usuário logado
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Você acessou o sistema como ',
                    style: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text: usuarioEmail ?? '',
                    style: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Botão para denúncia identificada
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: onSelecionarIdentificado,
                style: ElevatedButton.styleFrom(
                  // Cores dinâmicas baseadas na seleção
                  backgroundColor:
                  anonimo ? Colors.white : const Color(0xFF2A2F8C),
                  foregroundColor:
                  anonimo ? const Color(0xFF2A2F8C) : Colors.white,
                  side: const BorderSide(color: Color(0xFF2A2F8C), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Prosseguir com identificação',
                  style: GoogleFonts.lato(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Botão para denúncia anônima
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: onSelecionarAnonimo,
                style: ElevatedButton.styleFrom(
                  // Cores dinâmicas baseadas na seleção
                  backgroundColor:
                  anonimo ? const Color(0xFF2A2F8C) : Colors.white,
                  foregroundColor:
                  anonimo ? Colors.white : const Color(0xFF2A2F8C),
                  side: const BorderSide(color: Color(0xFF2A2F8C), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Continuar de forma anônima',
                  style: GoogleFonts.lato(fontSize: 16),
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
