/// ALTERAR_SENHA_WIDGET_DECORATION
///
/// Responsável por: Função utilitária para criar InputDecoration padronizada
/// para campos de senha com toggle de visibilidade.
/// Utilizado em: AlterarSenhaForm para manter consistência visual entre campos.

import 'package:flutter/material.dart';

/// INPUTDECORATION
///
/// Descrição: Cria InputDecoration padronizada para campos de senha com ícone
/// de toggle de visibilidade e bordas consistentes.
/// Parâmetros:
/// - obscure: Estado atual de visibilidade (true = oculta, false = visível)
/// - onToggle: Callback executado ao tocar no ícone de toggle
/// Retorno: InputDecoration configurada com bordas, padding e suffixIcon
///
/// Usado nos 3 campos de senha do formulário para manter consistência visual.
InputDecoration inputDecoration({
  required bool obscure,      // Estado de visibilidade da senha
  required VoidCallback onToggle,  // Ação do botão de toggle
}) {
  return InputDecoration(
    // Borda padrão (estado normal)
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),        // Bordas levemente arredondadas
      borderSide: const BorderSide(color: Colors.grey, width: 1.5),  // Cinza com espessura média
    ),
    // Borda quando campo está focado
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),        // Mesma curvatura
      borderSide: const BorderSide(color: Colors.grey, width: 1.5),  // Mesma cor (sem destaque)
    ),
    // Borda quando campo está habilitado mas não focado
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),        // Mesma curvatura
      borderSide: const BorderSide(color: Colors.grey, width: 1.5),  // Mesma cor
    ),
    // Padding interno do campo
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 12,  // Espaçamento lateral
      vertical: 14,    // Espaçamento vertical (altura confortável)
    ),
    // Ícone de toggle de visibilidade no final do campo
    suffixIcon: IconButton(
      icon: Icon(
        // Ícone muda baseado no estado de visibilidade
        obscure ? Icons.visibility_off : Icons.visibility,  // Olho fechado/aberto
        color: Colors.grey,  // Cor neutra para não chamar atenção
      ),
      onPressed: onToggle,  // Executa callback ao ser pressionado
    ),
  );
}

// Fim do arquivo alterar_senha_widget_decoration.dart
// 
// Função utilitária para InputDecoration com:
// - Bordas consistentes em todos os estados (normal, focado, habilitado)
// - Bordas arredondadas (8px) para suavidade visual
// - Cor cinza neutra para não competir com conteúdo
// - Padding interno confortável (12x14)
// - Ícone de toggle responsivo ao estado
// - Callback configurável para ação de toggle
// - Reutilizável nos 3 campos do formulário de senha
