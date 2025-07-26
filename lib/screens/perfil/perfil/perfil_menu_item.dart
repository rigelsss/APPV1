/// PERFIL_MENU_ITEM
///
/// Responsável por: Widget reutilizável para itens do menu de perfil com ícone,
/// título e seta indicativa de navegação.
/// Utilizado em: PerfilMenuList para criar itens consistentes do menu.

import 'package:flutter/material.dart';

/// Widget PerfilMenuItem
///
/// Descrição: ListTile personalizado com ícone à esquerda, título centralizado
/// e seta de navegação à direita.
class PerfilMenuItem extends StatelessWidget {
  final Widget icon;        // Ícone do item (geralmente SVG)
  final String title;       // Título do item
  final VoidCallback onTap; // Callback executado ao tocar

  const PerfilMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  /// BUILD
  ///
  /// Descrição: Constrói ListTile com ícone, título e seta de navegação.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget ListTile configurado
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,                              // Ícone à esquerda
      title: Text(title),                         // Título do item
      trailing: const Icon(Icons.chevron_right), // Seta indicativa à direita
      onTap: onTap,                               // Ação ao tocar
    );
  }

  // Fim da classe PerfilMenuItem
  // 
  // Widget reutilizável para itens de menu com:
  // - Ícone personalizável (SVG ou Icon)
  // - Título em texto simples
  // - Seta de navegação padrão
  // - Callback de toque configurável
  // - Layout consistente via ListTile
}
