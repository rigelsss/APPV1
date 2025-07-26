/// ALTERAR_EMAIL_WIDGETS
///
/// Responsável por: Função utilitária para criar InputDecoration padronizada
/// para campos do formulário de alteração de e-mail.
/// Utilizado em: AlterarEmailForm para manter consistência visual entre campos.

import 'package:flutter/material.dart';

/// INPUTDECORATION
///
/// Descrição: Cria InputDecoration padronizada para campos de texto com
/// bordas consistentes em todos os estados.
/// Parâmetros: nenhum
/// Retorno: InputDecoration configurada com bordas e estilo padrão
///
/// Usado nos 3 campos do formulário (senha, novo e-mail, confirmar e-mail).
InputDecoration inputDecoration() {
  return InputDecoration(
    // Borda padrão (estado normal)
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),              // Bordas levemente arredondadas
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),  // Cinza claro
    ),
    // Borda quando campo está habilitado mas não focado
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),              // Mesma curvatura
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),  // Mesma cor
    ),
    // Borda quando campo está focado
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),              // Mesma curvatura
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),  // Mesma cor (sem destaque)
    ),
  );
}

// Fim do arquivo alterar_email_widgets.dart
// 
// Função utilitária para InputDecoration com:
// - Bordas consistentes em todos os estados (normal, habilitado, focado)
// - Bordas arredondadas (8px) para suavidade visual
// - Cor cinza claro neutra (Colors.grey.shade400)
// - Espessura média (1.5) para visibilidade sem ser intrusiva
// - Sem padding interno (deixado para o campo decidir)
// - Reutilizável nos 3 campos do formulário
// - Estilo mais sutil que o formulário de senha (sem ícones)
