/// CATEGORIA_SELECTOR
///
/// Responsável por: Widget expansivo para seleção de categorias e subcategorias
/// de denúncias com ícones, estados visuais e callbacks.
/// Utilizado em: Sistema de denúncias para escolha do tipo de infração.

import 'package:flutter/material.dart';

/// Widget CategoriaSelector
///
/// Descrição: Lista expansiva de categorias com subcategorias aninhadas,
/// ícones personalizados e estados de seleção visuais.
class CategoriaSelector extends StatelessWidget {
  final List<dynamic> categorias;                              // Lista de categorias da API
  final Map<int, String> iconesPorCategoria;                   // Mapeamento ID → caminho do ícone
  final String? categoriaSelecionada;                          // Categoria atualmente selecionada
  final String? subcategoriaSelecionada;                       // Subcategoria atualmente selecionada
  final Set<int> categoriasExpandidas;                         // Índices das categorias expandidas
  final Function(String, int, String) onSubcategoriaSelecionada; // Callback: (nome, id, categoria)
  final Function(String) onCategoriaSelecionada;              // Callback: (nome)
  final Function(int) onToggleExpand;                         // Callback: (índice)

  const CategoriaSelector({
    super.key,
    required this.categorias,
    required this.iconesPorCategoria,
    required this.categoriaSelecionada,
    required this.subcategoriaSelecionada,
    required this.categoriasExpandidas,
    required this.onSubcategoriaSelecionada,
    required this.onCategoriaSelecionada,
    required this.onToggleExpand,
  });

  /// BUILD
  ///
  /// Descrição: Constrói lista expansiva de categorias com subcategorias aninhadas.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget ListView com categorias expansivas
  @override
  Widget build(BuildContext context) {
    // Estado vazio: exibe mensagem centralizada
    if (categorias.isEmpty) {
      return const Center(child: Text('Nenhuma categoria disponível.'));
    }

    // Lista principal de categorias
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        // Extração de dados da categoria
        final categoria = categorias[index];
        final int id = categoria['id'];                                    // ID da categoria
        final String texto = categoria['nome'] ?? 'Cateoria sem nome';     // Nome (com typo original)
        final String imagem = iconesPorCategoria[id] ?? 'assets/images/image-break.png'; // Ícone ou fallback
        final List<dynamic> tiposDenuncia = categoria['tiposDenuncia'] ?? []; // Subcategorias
        final isExpanded = categoriasExpandidas.contains(index);           // Estado de expansão

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  onCategoriaSelecionada(texto);
                  onToggleExpand(index);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Image.asset(
                      imagem,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/image-break.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                title: Text(texto, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: IconButton(
                  icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  onPressed: () => onToggleExpand(index),
                ),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tiposDenuncia.map<Widget>((sub) {
                      final String nomeSub = sub['nome'];
                      final int idSub = sub['id'];
                      final bool isSelected = subcategoriaSelecionada == nomeSub;

                      return GestureDetector(
                        onTap: () => onSubcategoriaSelecionada(nomeSub, idSub, texto),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1B8C00) : const Color(0xFFB9CD23),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            nomeSub,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.white : Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const Divider(indent: 20, endIndent: 20, height: 6, color: Color.fromRGBO(195, 182, 182, 1)),
            ],
          ),
        );
      },
    );
  }
}
