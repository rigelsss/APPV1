/// ALTERAR_PERFIL_WIDGET_DECORATION
///
/// Responsável por: Função utilitária para criar campos de formulário padronizados
/// com label, validação e decoração consistente.
/// Utilizado em: EditarPerfilForm para manter consistência visual entre campos.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// BUILDLABELEDFIELD
///
/// Descrição: Constrói campo de formulário com label superior, TextFormField
/// e decoração padronizada.
/// Parâmetros:
/// - label: Texto do label acima do campo
/// - controller: TextEditingController para gerenciar texto
/// - validator: Função de validação do campo
/// - inputFormatters: Formatadores opcionais (máscaras)
/// - keyboardType: Tipo de teclado opcional
/// Retorno: Widget Column com label e campo
///
/// Usado nos 3 campos do formulário (nome, CPF, telefone).
Widget buildLabeledField({
  required String label,                              // Label obrigatório
  required TextEditingController controller,          // Controller obrigatório
  required FormFieldValidator<String> validator,     // Validator obrigatório
  List<TextInputFormatter>? inputFormatters,         // Formatadores opcionais
  TextInputType? keyboardType,                       // Tipo de teclado opcional
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,  // Alinha à esquerda
    children: [
      // Label do campo
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,  // Negrito para destaque
          fontSize: 14,                 // Tamanho padrão
        ),
      ),
      const SizedBox(height: 8),  // Espaço entre label e campo
      
      // Campo de texto com validação
      TextFormField(
        controller: controller,              // Gerencia texto
        validator: validator,                // Função de validação
        inputFormatters: inputFormatters,    // Máscaras (se fornecidas)
        keyboardType: keyboardType,          // Tipo de teclado (se fornecido)
        decoration: InputDecoration(
          isDense: true,  // Layout mais compacto
          // Borda padrão (estado normal)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),        // Bordas arredondadas
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          // Borda quando habilitado mas não focado
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),        // Mesma curvatura
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          // Borda quando focado
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),        // Mesma curvatura
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          // Padding interno do campo
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,  // Espaçamento lateral
            vertical: 14,    // Espaçamento vertical
          ),
        ),
      ),
    ],
  );
}

// Fim do arquivo alterar_perfil_widget_decoration.dart
// 
// Função utilitária para campos de formulário com:
// - Label superior em negrito
// - TextFormField com validação integrada
// - Bordas consistentes em todos os estados
// - Suporte a formatadores (máscaras)
// - Tipo de teclado configurável
// - Layout compacto (isDense: true)
// - Padding interno confortável
// - Reutilizável em todos os campos do formulário
