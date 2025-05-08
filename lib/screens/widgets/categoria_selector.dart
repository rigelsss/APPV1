import 'package:flutter/material.dart';
import '../../models/denuncia_data.dart';

class CategoriaSelector extends StatelessWidget {
  final List<dynamic> categorias;
  final Map<int, String> iconesPorCategoria;
  final String? categoriaSelecionada;
  final String? subcategoriaSelecionada;
  final Set<int> categoriasExpandidas;
  final Function(String, int) onSubcategoriaSelecionada;
  final Function(String) onCategoriaSelecionada;
  final Function(int) onToggleExpand;

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

  @override
  Widget build(BuildContext context) {
    if (categorias.isEmpty) {
      return const Center(child: Text('Nenhuma categoria disponível.'));
    }

    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        final int id = categoria['id'];
        final String texto = categoria['nome'] ?? 'Sem nome';
        final String imagem = iconesPorCategoria[id] ?? 'assets/images/image-break.png';
        final List<dynamic> tiposDenuncia = categoria['tiposDenuncia'] ?? [];
        final isExpanded = categoriasExpandidas.contains(index);
        final selecionado = categoriaSelecionada == texto;

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () => onCategoriaSelecionada(texto),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selecionado) const Icon(Icons.check, color: Colors.green),
                    IconButton(
                      icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                      onPressed: () => onToggleExpand(index),
                    ),
                  ],
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
                        onTap: () => onSubcategoriaSelecionada(nomeSub, idSub),
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
