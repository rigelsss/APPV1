/// PAINEL_CONFIRMAR_ENDERECO
///
/// Responsável por: Painel inferior da tela de localização com controles de endereço.
/// Utilizado em: Interface da etapa de localização das denúncias.
/// 
/// Este painel contém:
/// - Título e instruções para o usuário
/// - Campo de busca (somente leitura) que abre modal de busca
/// - Botão dinâmico (Pesquisar/Confirmar) baseado no estado
/// - Layout responsivo para tablets e celulares
/// - Design com bordas arredondadas e sombra

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PainelConfirmarEndereco extends StatelessWidget {
  final TextEditingController controller; // Controlador do campo de endereço
  final bool enderecoValido;             // Estado de validação do endereço
  final VoidCallback onPesquisarPress;   // Callback para abrir busca manual
  final VoidCallback onConfirmarPress;   // Callback para confirmar endereço

  const PainelConfirmarEndereco({
    super.key,
    required this.controller,
    required this.enderecoValido,
    required this.onPesquisarPress,
    required this.onConfirmarPress,
  });

  /// isTablet
  ///
  /// Descrição: Detecta se o dispositivo é tablet baseado na largura da tela.
  /// Parâmetros:
  /// - context: contexto para obter dimensões da tela
  /// Retorno: bool - true se largura >= 500px
  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 500;
  }

  /// Widget PainelConfirmarEndereco
  ///
  /// Descrição: Painel inferior responsivo com controles de endereço.
  /// Adapta layout para tablets e celulares.
  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)), // Bordas arredondadas superiores
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)], // Sombra para destaque
        ),
        child: Center(
          child: ConstrainedBox(
            // Layout responsivo: limita largura em tablets
            constraints: tablet
                ? const BoxConstraints(maxWidth: 500)
                : const BoxConstraints(maxWidth: double.infinity),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título da seção
                Text(
                  'Localização da Infração',
                  style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                // Instruções para o usuário
                const Text(
                  'Arraste o mapa para mover o marcador',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Campo de busca (somente leitura) que abre modal
                GestureDetector(
                  onTap: onPesquisarPress, // Abre modal de busca manual
                  child: AbsorbPointer( // Impede interação direta com o TextField
                    child: TextField(
                      controller: controller,
                      readOnly: true, // Campo apenas para exibição
                      decoration: InputDecoration(
                        hintText: 'Pesquisar',
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        suffixIcon: const Icon(Icons.search, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botão dinâmico baseado no estado do endereço
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // Ação muda baseada na validação do endereço
                    onPressed: enderecoValido ? onConfirmarPress : onPesquisarPress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2F8C), // Azul SUDEMA
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      // Texto muda baseado na validação do endereço
                      enderecoValido ? 'Confirmar endereço' : 'Pesquisar',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
