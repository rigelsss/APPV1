import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/screens/denuncia/categoria/controller/categorias_controller.dart';
import 'package:sudema_app/screens/widgets/categoria_selector.dart';

class CategoriaContent extends StatelessWidget {
  final CategoriasController controller;
  final VoidCallback onAvancar;
  final VoidCallback onRebuild;

  const CategoriaContent({
    super.key,
    required this.controller,
    required this.onAvancar,
    required this.onRebuild,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.isLoadingCategorias) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Categoria da infração',
              style: GoogleFonts.lato(fontSize: 24),
            ),
          ),
          Expanded(
            child: CategoriaSelector(
              categorias: controller.categorias,
              iconesPorCategoria: controller.iconesPorCategoria,
              categoriaSelecionada: controller.categoriaSelecionada,
              subcategoriaSelecionada: controller.subcategoriaSelecionada,
              categoriasExpandidas: controller.categoriasExpandidas,
              onCategoriaSelecionada: (texto) {
                controller.selecionarCategoria(texto);
                onRebuild();
              },
              onSubcategoriaSelecionada: (nome, id, texto) {
                controller.selecionarSubcategoria(nome, id, texto);
                onRebuild();
              },
              onToggleExpand: (index) {
                controller.alternarExpansaoCategoria(index);
                onRebuild();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A2F8C),
                disabledBackgroundColor: Colors.grey[500],
                minimumSize: const Size.fromHeight(52.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: (controller.categoriaSelecionada != null &&
                      controller.subcategoriaSelecionada != null &&
                      controller.subcategoriaSelecionada!.isNotEmpty)
                  ? onAvancar
                  : null,
              child: Center(
                child: Text(
                  'Selecionar Categoria',
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
