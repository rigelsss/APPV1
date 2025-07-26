/// HOME_BODY
///
/// Responsável por: Corpo principal da tela inicial com banner, serviços e notícias.
/// Utilizado em: HomeScreen como conteúdo principal da aba Home.
/// 
/// Estrutura:
/// - Banner carrossel com ações principais
/// - Seção de serviços da SUDEMA
/// - Carrossel de últimas notícias
/// - Layout responsivo para mobile e tablet

import 'package:flutter/material.dart';
import 'package:sudema_app/models/noticia.dart';
import 'package:sudema_app/screens/home/banner_carrossel.dart';
import 'package:sudema_app/screens/home/servicos_carrossel.dart';
import 'package:sudema_app/screens/home/titulo_com_linha.dart';
import 'package:sudema_app/screens/home/noticias_carrossel.dart'; 

/// Widget HomeBody
///
/// Descrição: Conteúdo principal da home com layout em coluna contendo banner,
/// serviços e notícias, todos com design responsivo.
class HomeBody extends StatelessWidget {
  final List<Noticia> noticias;                    // Notícias carregadas da API
  final VoidCallback onSelecionarDenuncia;         // Callback para navegar para denúncias
  final VoidCallback onSelecionarNoticias;         // Callback para navegar para notícias
  final VoidCallback onSelecionarBalneabildiade;   // Callback para navegar para balneabilidade
  final VoidCallback onSelecionarContatos;         // Callback para navegar para contatos

  const HomeBody({
    super.key,
    required this.noticias,
    required this.onSelecionarDenuncia,
    required this.onSelecionarNoticias,
    required this.onSelecionarBalneabildiade,
    required this.onSelecionarContatos
  });

  /// BUILD
  ///
  /// Descrição: Constrói layout principal da home com espaçamentos responsivos.
  /// Parâmetros:
  /// - context: Contexto do widget para MediaQuery
  /// Retorno: Widget SafeArea com conteúdo scrollável
  @override
  Widget build(BuildContext context) {
    // Obtém dimensões da tela para layout responsivo
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return SafeArea(
      child: SingleChildScrollView(
        // Padding responsivo baseado no tamanho da tela
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,   // 3% da largura
          vertical: screenHeight * 0.01,    // 1% da altura
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Espaçamento inicial
            SizedBox(height: screenHeight * 0.02),
            
            // Seção 1: Banner carrossel com ações principais
            BannerCarrossel(
              onTapDenuncia: onSelecionarDenuncia, // Navega para denúncias
            ),
            SizedBox(height: screenHeight * 0.03),
            
            // Seção 2: Título e carrossel de serviços
            const TituloComLinha(titulo: 'Nossos serviços'),
            SizedBox(height: screenHeight * 0.02),
            // Carrossel de serviços da SUDEMA
            ServicosCarrossel(
              onSelecionar: (key) {
                // Roteamento baseado na chave do serviço selecionado
                if (key == 'balneabilidade') {
                  onSelecionarBalneabildiade();  // Navega para balneabilidade
                } else if (key == 'denuncias') {
                  onSelecionarDenuncia();        // Navega para denúncias
                }
                // Outros serviços abrem URLs externas (tratado no próprio carrossel)
              },
            ),
            SizedBox(height: screenHeight * 0.015),
            
            // Seção 3: Título e carrossel de notícias
            TituloComLinha(
              titulo: 'Últimas notícias',
              verTodas: true,                    // Exibe botão "Ver todas"
              onVerTodas: onSelecionarNoticias,  // Navega para página completa de notícias
            ),
            SizedBox(height: screenHeight * 0.02),
            
            // Carrossel de notícias
            _buildNoticias(context, screenHeight),
          ],
        ),
      ),
    );
  }

  /// _BUILDNOTICIAS
  ///
  /// Descrição: Método auxiliar que constrói o carrossel de notícias.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// - screenHeight: Altura da tela (não utilizada atualmente)
  /// Retorno: Widget NoticiasCarrossel com lista de notícias
  Widget _buildNoticias(BuildContext context, double screenHeight) {
    return NoticiasCarrossel(noticias: noticias);
  }

  // Fim da classe HomeBody
  // Layout principal da home com:
  // - Banner carrossel interativo
  // - Serviços da SUDEMA (internos e externos)
  // - Últimas notícias com navegação
  // - Design responsivo para mobile e tablet
}
