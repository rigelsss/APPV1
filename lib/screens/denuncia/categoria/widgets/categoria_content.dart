/// CATEGORIA_CONTENT
///
/// Responsável por: Interface da etapa 2 do fluxo de denúncias - seleção de categoria.
/// Utilizado em: Segunda aba do processo de criação de denúncias ambientais.
/// 
/// Este widget apresenta:
/// - Lista hierárquica de categorias de infrações ambientais
/// - Seleção de categoria principal e subcategoria específica
/// - Validação para habilitar botão de avanço
/// - Layout responsivo para tablets e celulares
/// - Integração com CategoriaSelector para interface expansível

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/screens/denuncia/categoria/controller/categorias_controller.dart';
import 'package:sudema_app/screens/widgets/categoria_selector.dart';

class CategoriaContent extends StatelessWidget {
  final CategoriasController controller; // Controlador com dados e estado das categorias
  final VoidCallback onAvancar;          // Callback para avançar para próxima etapa
  final VoidCallback onRebuild;          // Callback para rebuild da interface

  const CategoriaContent({
    super.key,
    required this.controller,
    required this.onAvancar,
    required this.onRebuild,
  });

  /// Widget CategoriaContent
  ///
  /// Descrição: Interface de seleção de categorias de infrações ambientais.
  /// Contém lista expansível de categorias e botão de confirmação.
  @override
  Widget build(BuildContext context) {
    // Exibe loading enquanto carrega categorias da API
    if (controller.isLoadingCategorias) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Detecta se é tablet para layout responsivo
        final bool isTablet = constraints.maxWidth >= 600;

        return Container(
          color: Colors.white,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: ConstrainedBox(
            // Limita largura em tablets para melhor legibilidade
            constraints: BoxConstraints(
              maxWidth: isTablet ? 500 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título da etapa
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    'Categoria da infração',
                    style: GoogleFonts.lato(fontSize: 24),
                  ),
                ),
                // Lista expansível de categorias e subcategorias
                Expanded(
                  child: CategoriaSelector(
                    categorias: controller.categorias,                     // Dados da API
                    iconesPorCategoria: controller.iconesPorCategoria,     // Mapeamento de ícones
                    categoriaSelecionada: controller.categoriaSelecionada, // Estado atual
                    subcategoriaSelecionada: controller.subcategoriaSelecionada,
                    categoriasExpandidas: controller.categoriasExpandidas, // Controle de expansão
                    // Callback para seleção de categoria principal
                    onCategoriaSelecionada: (texto) {
                      controller.selecionarCategoria(texto);
                      onRebuild(); // Atualiza interface
                    },
                    // Callback para seleção de subcategoria específica
                    onSubcategoriaSelecionada: (nome, id, texto) {
                      controller.selecionarSubcategoria(nome, id, texto);
                      onRebuild(); // Atualiza interface
                    },
                    // Callback para expandir/contrair categorias
                    onToggleExpand: (index) {
                      controller.alternarExpansaoCategoria(index);
                      onRebuild(); // Atualiza interface
                    },
                  ),
                ),
                // Botão de confirmação da seleção
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2F8C), // Azul SUDEMA
                        disabledBackgroundColor: Colors.grey[500], // Cinza quando desabilitado
                        minimumSize: const Size.fromHeight(52.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      // Botão habilitado apenas quando categoria e subcategoria estão selecionadas
                      onPressed: (controller.categoriaSelecionada != null &&
                          controller.subcategoriaSelecionada != null &&
                          controller.subcategoriaSelecionada!.isNotEmpty)
                          ? onAvancar // Avança para etapa de localização
                          : null,     // Desabilitado se seleção incompleta
                      child: Center(
                        child: Text(
                          'Selecionar Categoria',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
