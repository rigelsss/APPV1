/// TITULO_COM_LINHA
///
/// Responsável por: Widget reutilizável para títulos de seções com linha decorativa
/// e botão opcional "Ver todas".
/// Utilizado em: Seções da home (serviços, notícias) para criar hierarquia visual.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget TituloComLinha
///
/// Descrição: Título centralizado com linha decorativa à direita e botão
/// opcional "Ver todas" para navegação adicional.
class TituloComLinha extends StatelessWidget {
  final String titulo;              // Texto do título a ser exibido
  final bool verTodas;              // Se deve exibir botão "Ver todas"
  final VoidCallback? onVerTodas;   // Callback para botão "Ver todas"

  const TituloComLinha({
    super.key,
    required this.titulo,
    this.verTodas = false,          // Padrão: não exibe botão
    this.onVerTodas,
  });

  /// BUILD
  ///
  /// Descrição: Constrói layout horizontal com título, linha e botão opcional.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Align com Row contendo elementos do título
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, // Centraliza todo o conjunto
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Título principal da seção
          Text(
            titulo,
            style: GoogleFonts.lato(
              fontSize: 22, 
              fontWeight: FontWeight.normal
            ),
          ),
          const SizedBox(width: 8), // Espaço entre título e linha
          
          // Linha decorativa que se expande
          const Expanded(
            child: Divider(
              color: Color(0xFFB8B8B8),  // Cinza claro
              thickness: 2,              // Espessura da linha
            ),
          ),
          
          // Botão "Ver todas" condicional
          if (verTodas && onVerTodas != null)
            TextButton(
              onPressed: onVerTodas,
              child: Text(
                'Ver todas',
                style: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFB8B8B8)  // Mesma cor da linha
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Fim da classe TituloComLinha
  // Widget reutilizável para:
  // - Títulos de seções com linha decorativa
  // - Botão opcional "Ver todas" para navegação
  // - Layout centralizado e responsivo
  // - Estilo consistente com fonte Lato
}
