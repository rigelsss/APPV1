/// BALNEABILIDADE_HEADER
///
/// Responsável por: Exibir cabeçalho da tela de balneabilidade com título, contador de trechos
/// monitorados e filtro de classificação (próprias/impróprias/todas).
/// Utilizado em: Parte superior da tela de balneabilidade, acima dos filtros e mapa.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';
import 'package:sudema_app/screens/balneabilidade/widgets/filtros_widgets.dart';

/// Widget PraiasHeader
///
/// Descrição: Cabeçalho da tela de balneabilidade com título, estatísticas e filtro principal.
/// Inclui contador dinâmico de trechos monitorados e dropdown para classificação.
class PraiasHeader extends StatelessWidget {
  const PraiasHeader({super.key});

  /// BUILD
  ///
  /// Descrição: Constrói o cabeçalho com título e barra de informações/filtros.
  /// Parâmetros:
  /// - context: Contexto do widget para acesso ao Provider
  /// Retorno: Widget Column com estrutura do cabeçalho
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BalneabilidadeController>();

    return Column(
      children: [
        // Container do título principal
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: Text(
            "Balneabilidade",
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w400),
          ),
        ),
        // Barra cinza com informações e filtro de classificação
        Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Seção esquerda: contador de trechos monitorados
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Trechos monitorados",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  // Número dinâmico baseado na quantidade de estações carregadas da API
                  Text(
                    "${controller.estacoes.length}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(), // Empurra filtro para a direita
              // Seção direita: filtro de classificação das praias
              SizedBox(
                width: 200,
                height: 35,
                // PopupMenuButton com opções de classificação
                child: PopupMenuButton<String>(
                  onSelected: controller.toggleClassificacao, // Callback para mudar filtro
                  itemBuilder: (_) => [
                    // Itens do menu com radio buttons
                    _radioMenuItem(context, ClassificacaoLabels.todas),      // Mostrar tudo
                    _radioMenuItem(context, ClassificacaoLabels.proprias),   // Apenas próprias
                    _radioMenuItem(context, ClassificacaoLabels.improprias), // Apenas impróprias
                  ],
                  // Botão visual do dropdown com label atual
                  child: popupButton(controller.getClassificacaoLabel()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// _RADIOMENUITEM
  ///
  /// Descrição: Cria item de menu com radio button para seleção de classificação.
  /// Parâmetros:
  /// - context: Contexto para acesso ao controller e navegação
  /// - value: Valor da opção (todas/próprias/impróprias)
  /// Retorno: PopupMenuItem com radio button e texto
  PopupMenuItem<String> _radioMenuItem(BuildContext context, String value) {
    final controller = context.read<BalneabilidadeController>();

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          // Radio button que mostra seleção atual
          Radio<String>(
            value: value,
            groupValue: controller.getClassificacaoLabel(), // Estado atual do filtro
            onChanged: (_) => Navigator.pop(context, value), // Fecha menu e seleciona
          ),
          const SizedBox(width: 8),
          // Texto da opção
          Text(value),
        ],
      ),
    );
  }
}
