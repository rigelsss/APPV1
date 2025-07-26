/// BANNER_CARROSSEL
///
/// Responsável por: Carrossel de banners promocionais na home com navegação para
/// diferentes seções do app (denúncias, monumentos, jardim botânico).
/// Utilizado em: Topo da home para destacar ações principais da SUDEMA.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/monumentos/monumentos.dart';
import 'package:sudema_app/screens/jardim/jardim.dart';

/// Widget BannerCarrossel
///
/// Descrição: Carrossel responsivo com 3 banners que adapta layout entre
/// PageView (mobile) e ListView horizontal (tablet).
class BannerCarrossel extends StatefulWidget {
  final VoidCallback onTapDenuncia;  // Callback para navegar para denúncias

  const BannerCarrossel({
    super.key,
    required this.onTapDenuncia,
  });

  @override
  State<BannerCarrossel> createState() => _BannerCarrosselState();
}

class _BannerCarrosselState extends State<BannerCarrossel> {
  // Controller para PageView (usado apenas em mobile)
  final PageController _controller = PageController(viewportFraction: 1.02);
  int _paginaAtual = 0;  // Índice da página atual no carrossel

  // Lista de imagens dos banners promocionais
  final List<String> imagens = [
    'assets/images/banner1.png',  // Banner 1: Denúncias
    'assets/images/banner2.png',  // Banner 2: Monumentos
    'assets/images/banner3.png',  // Banner 3: Jardim Botânico
  ];

  /// _HANDLETAP
  ///
  /// Descrição: Gerencia navegação baseada no banner tocado.
  /// Parâmetros:
  /// - index: Índice do banner (0=denúncias, 1=monumentos, 2=jardim)
  /// Retorno: void
  void _handleTap(int index) {
    if (index == 0) {
      // Banner 1: Navega para denúncias via callback
      widget.onTapDenuncia();
    } else if (index == 1) {
      // Banner 2: Navega para tela de monumentos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Monumentos()),
      );
    } else if (index == 2) {
      // Banner 3: Navega para tela do jardim botânico
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Jardim()),
      );
    }
  }

  /// BUILD
  ///
  /// Descrição: Constrói carrossel responsivo - ListView para tablet, PageView para mobile.
  /// Parâmetros:
  /// - context: Contexto do widget para MediaQuery
  /// Retorno: Widget Column com carrossel e indicadores
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;  // Define breakpoint para tablet

    if (isTablet) {
      // Layout para tablet: ListView horizontal com todos os banners visíveis
      final bannerWidth = width * 0.53;      // 53% da largura da tela
      final bannerHeight = bannerWidth * 0.3; // Altura proporcional

      return Column(
        children: [
          SizedBox(
            height: bannerHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: imagens.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16), // Espaço entre banners
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handleTap(index), // Navegação ao tocar
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                    child: Image.asset(
                      imagens[index],
                      width: bannerWidth,
                      height: bannerHeight,
                      fit: BoxFit.cover, // Preenche mantendo proporção
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Indicadores estáticos (não acompanham scroll por simplicidade)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imagens.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade400, // Todos cinzas no tablet
                ),
              );
            }),
          ),
        ],
      );
    } else {
      // Layout para mobile: PageView com um banner por vez
      final height = width * 0.25; // 25% da largura como altura

      return Column(
        children: [
          SizedBox(
            height: height,
            child: PageView.builder(
              controller: _controller,
              itemCount: imagens.length,
              // Atualiza indicador quando página muda
              onPageChanged: (index) {
                setState(() => _paginaAtual = index);
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handleTap(index), // Navegação ao tocar
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                      child: Image.asset(
                        imagens[index],
                        fit: BoxFit.cover, // Preenche mantendo proporção
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Indicadores dinâmicos que acompanham a página atual
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imagens.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Azul SUDEMA se ativo, cinza se inativo
                  color: _paginaAtual == index 
                      ? const Color(0xFF2A2F8C) 
                      : Colors.grey.shade400,
                ),
              );
            }),
          ),
        ],
      );
    }
  }

  // Fim da classe BannerCarrossel
  // Carrossel responsivo com:
  // - 3 banners promocionais com navegação
  // - Layout adaptativo (ListView/PageView)
  // - Indicadores visuais
  // - Bordas arredondadas e transições suaves
}

