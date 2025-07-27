/// IMAGE_PICKER
///
/// Responsável por: Widget reutilizável para seleção de imagens da galeria
/// com preview e interface de upload intuitiva.
/// Utilizado em: Sistema de denúncias para anexar evidências fotográficas.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget ImagePickerWidget
///
/// Descrição: Container clicável que permite seleção de imagem da galeria
/// com preview da imagem selecionada ou placeholder de upload.
class ImagePickerWidget extends StatelessWidget {
  final XFile? image;                        // Imagem atualmente selecionada
  final void Function(XFile?) onImagePicked; // Callback quando imagem é selecionada

  const ImagePickerWidget({
    super.key,
    required this.image,
    required this.onImagePicked,
  });

  /// _PICKIMAGE
  ///
  /// Descrição: Método privado para abrir galeria e selecionar imagem.
  /// Parâmetros:
  /// - context: Contexto para operações assíncronas
  /// Retorno: Future<void>
  ///
  /// Fonte: ImageSource.gallery (apenas galeria, não câmera)
  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    // Abre galeria para seleção de imagem
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    onImagePicked(pickedFile);  // Executa callback com imagem selecionada
  }

  /// BUILD
  ///
  /// Descrição: Constrói container clicável com estado condicional (placeholder vs preview).
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget GestureDetector com container de upload
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),  // Abre galeria ao tocar
      child: Container(
        height: 100,                     // Altura fixa do container
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),  // Borda cinza
          borderRadius: BorderRadius.circular(5),  // Bordas levemente arredondadas
        ),
        child: Center(
          // Estado condicional: placeholder ou preview da imagem
          child: image == null
              // Estado 1: Nenhuma imagem selecionada - exibe placeholder
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload, color: Colors.grey, size: 30),  // Ícone de upload
                    SizedBox(height: 8),
                    Text('Clique para enviar', style: TextStyle(color: Colors.grey)), // Instrução
                  ],
                )
              // Estado 2: Imagem selecionada - exibe preview
              : Image.file(
                  File(image!.path),        // Carrega imagem do caminho
                  fit: BoxFit.cover,        // Preenche container mantendo proporção
                  width: double.infinity,   // Ocupa toda largura
                ),
        ),
      ),
    );
  }

  // Fim da classe ImagePickerWidget
  // 
  // Widget de seleção de imagem com:
  // 
  // 🖼️ FUNCIONALIDADE:
  // - Seleção de imagem da galeria
  // - Preview da imagem selecionada
  // - Placeholder intuitivo para upload
  // - Callback para comunicação com widget pai
  // 
  // 🎨 INTERFACE:
  // - Container com altura fixa (100px)
  // - Borda cinza para delimitação
  // - Ícone de upload + texto instrutivo
  // - Preview com BoxFit.cover
  // 
  // 📱 UX:
  // - GestureDetector para área clicável completa
  // - Estados visuais claros
  // - Feedback imediato após seleção
  // - Interface familiar de upload
  // 
  // 🔧 INTEGRAÇÃO:
  // - Plugin image_picker para galeria
  // - XFile para compatibilidade
  // - Callback onImagePicked para comunicação
  // - Reutilizável em diferentes contextos
}
