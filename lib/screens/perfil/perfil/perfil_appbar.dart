/// PERFIL_APPBAR
///
/// Responsável por: AppBar personalizada da tela de perfil com saudação personalizada
/// usando o primeiro nome do usuário e botão de voltar condicional.
/// Utilizado em: Tela de perfil como cabeçalho principal.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget PerfilHeader
///
/// Descrição: AppBar que implementa PreferredSizeWidget com saudação personalizada
/// e navegação condicional baseada no contexto de navegação.
class PerfilHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? nome;  // Nome completo do usuário (opcional)

  const PerfilHeader({required this.nome, super.key});

  /// BUILD
  ///
  /// Descrição: Constrói AppBar com saudação personalizada e navegação condicional.
  /// Parâmetros:
  /// - context: Contexto do widget para verificação de navegação
  /// Retorno: Widget AppBar configurada
  @override
  Widget build(BuildContext context) {
    // Extrai primeiro nome ou usa fallback se nome não disponível
    final primeiroNome = (nome ?? 'Nome não encontrado').split(' ').first;

    return AppBar(
      centerTitle: false,           // Título alinhado à esquerda
      titleSpacing: 0,              // Remove espaçamento extra do título
      // Título com saudação personalizada
      title: Text(
        'Olá, $primeiroNome',
        style: GoogleFonts.lato(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Estilo da AppBar
      backgroundColor: Colors.white,     // Fundo branco
      foregroundColor: Colors.black87,   // Texto e ícones escuros
      elevation: 0,                      // Remove sombra
      scrolledUnderElevation: 0,         // Remove sombra ao rolar
      // Botão de voltar condicional
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),  // Volta para tela anterior
            )
          : null,  // Não exibe botão se não pode voltar
    );
  }

  /// PREFERREDSIZE
  ///
  /// Descrição: Define altura padrão da AppBar conforme Material Design.
  /// Retorno: Size com altura padrão da toolbar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // Fim da classe PerfilHeader
  // 
  // AppBar personalizada com:
  // - Saudação com primeiro nome do usuário
  // - Botão de voltar condicional
  // - Estilo limpo sem sombras
  // - Fonte Lato para consistência visual
}
