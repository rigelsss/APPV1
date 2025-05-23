import 'package:flutter/material.dart';
import 'package:sudema_app/models/noticia.dart';
import 'package:sudema_app/screens/home/noticia_card.dart';
import 'package:sudema_app/screens/home/banner_denuncia.dart';
import 'package:sudema_app/screens/home/servicos_carrossel.dart';
import 'package:sudema_app/screens/home/titulo_com_linha.dart';

class HomeBody extends StatelessWidget {
  final List<Noticia> noticias;
  final VoidCallback onSelecionarDenuncia;
  final VoidCallback onSelecionarNoticias;
  final VoidCallback onSelecionarBalneabildiade;

  const HomeBody({
    super.key,
    required this.noticias,
    required this.onSelecionarDenuncia,
    required this.onSelecionarNoticias,
    required this.onSelecionarBalneabildiade,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            BannerDenuncia(
              onTap: onSelecionarDenuncia,

            ),
            SizedBox(height: screenHeight * 0.03),
            const TituloComLinha(titulo: 'Nossos serviços'),
            SizedBox(height: screenHeight * 0.02),
            ServicosCarrossel(
              onSelecionar: (label) {
                if (label == 'Balneabilidade') {
                  onSelecionarBalneabildiade();
                } else if (label == 'Denuncias') {
                  onSelecionarDenuncia();
                }
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            TituloComLinha(
              titulo: 'Últimas notícias',
              verTodas: true,
              onVerTodas: onSelecionarNoticias,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildNoticias(context, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticias(BuildContext context, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.4,
      child: noticias.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          final noticia = noticias[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: NoticiaCard(noticia: noticia),
          );
        },
      ),
    );
  }
}
