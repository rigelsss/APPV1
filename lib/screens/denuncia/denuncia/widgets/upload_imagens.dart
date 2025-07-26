/// UPLOAD_IMAGENS
///
/// Responsável por: Widget para seleção e exibição de imagens da denúncia.
/// Utilizado em: Etapa final da denúncia para adicionar evidências visuais.
/// 
/// Este widget oferece:
/// - Área de upload com borda pontilhada
/// - Estado vazio com ícone e instruções
/// - Lista horizontal de imagens selecionadas
/// - Integração com ImagePicker para seleção múltipla
/// - Preview das imagens em miniatura
/// - Interface intuitiva com toque para adicionar

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadImagensWidget extends StatelessWidget {
  final List<XFile> imagens;                    // Lista de imagens selecionadas
  final Future<void> Function() onAdicionar;    // Callback para adicionar novas imagens

  const UploadImagensWidget({
    super.key,
    required this.imagens,
    required this.onAdicionar,
  });

  /// Widget UploadImagensWidget
  ///
  /// Descrição: Área de upload com estados vazio e preenchido.
  /// Permite seleção múltipla de imagens com preview horizontal.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdicionar, // Toque em qualquer lugar abre seletor de imagens
      child: DottedBorder(
        color: const Color.fromARGB(255, 191, 191, 191), // Cinza claro
        strokeWidth: 1.5,
        dashPattern: [8, 4], // Padrão de linha pontilhada
        borderType: BorderType.RRect,
        radius: const Radius.circular(6),
        child: Container(
          height: 120,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: imagens.isEmpty
              ? // Estado vazio: ícone e instruções
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload_outlined, size: 32, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Clique para enviar', style: TextStyle(color: Colors.grey)),
                  ],
                )
              : // Estado preenchido: lista horizontal de imagens
              ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagens.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    // Preview de cada imagem selecionada
                    return Image.file(
                      File(imagens[index].path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover, // Ajusta imagem ao container
                    );
                  },
                ),
        ),
      ),
    );
  }
}
