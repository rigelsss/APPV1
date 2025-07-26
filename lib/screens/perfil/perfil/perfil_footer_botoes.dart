/// PERFIL_FOOTER_BOTOES
///
/// Responsável por: Botões de ação do rodapé da tela de perfil (logout e desativar conta)
/// com confirmação de segurança e estilos diferenciados.
/// Utilizado em: Parte inferior da tela de perfil para ações críticas da conta.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/utils/logout_helper.dart';

/// Widget PerfilFooterButtons
///
/// Descrição: Column com dois botões - logout (azul, destaque) e desativar conta
/// (vermelho, secundário) com ícones e confirmações de segurança.
class PerfilFooterButtons extends StatelessWidget {
  final VoidCallback onLogout;  // Callback para ação de logout

  const PerfilFooterButtons({
    required this.onLogout,
    super.key,
  });

  /// BUILD
  ///
  /// Descrição: Constrói coluna com botões de logout e desativar conta.
  /// Parâmetros:
  /// - context: Contexto do widget para navegação e diálogos
  /// Retorno: Widget Column com dois botões estilizados
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botão principal: Logout
        SizedBox(
          width: double.infinity,  // Ocupa toda largura disponível
          child: ElevatedButton.icon(
            // Ação com confirmação de segurança
            onPressed: () {
              confirmarLogout(context, onLogout: onLogout);  // Helper com diálogo de confirmação
            },
            // Ícone de logout
            icon: const Icon(Icons.logout, color: Colors.white),
            // Texto do botão
            label: Text(
              'Sair',
              style: GoogleFonts.lato(
                color: Colors.white, 
                fontSize: 16
              ),
            ),
            // Estilo do botão principal
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2F8C),  // Azul institucional SUDEMA
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),  // Bordas bem arredondadas
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),  // Padding vertical generoso
            ),
          ),
        ),
        const SizedBox(height: 8),  // Espaço entre botões
        // Botão secundário: Desativar conta
        TextButton.icon(
          // Navega para tela de desativação
          onPressed: () {
            Navigator.pushNamed(context, '/deletar-conta');
          },
          // Ícone SVG de lixeira
          icon: SvgPicture.asset(
            'assets/icon/lixo.svg',
            width: 22,
            height: 22,
          ),
          // Texto em vermelho para indicar ação destrutiva
          label: Text(
            'Desativar Conta',
            style: GoogleFonts.lato(
              fontSize: 14, 
              color: Colors.red  // Vermelho para ação crítica
            ),
          ),
        ),
      ],
    );
  }

  // Fim da classe PerfilFooterButtons
  // 
  // Botões de ação do perfil com:
  // - Botão de logout com confirmação de segurança
  // - Botão de desativar conta (ação destrutiva)
  // - Estilos diferenciados (azul vs vermelho)
  // - Ícones apropriados para cada ação
  // - Layout responsivo com largura total
  // - Integração com helper de logout
}
