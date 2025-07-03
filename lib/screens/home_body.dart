import 'package:flutter/material.dart';
import 'package:sudema_app/models/noticia.dart';
import 'package:sudema_app/screens/home/banner_carrossel.dart';
import 'package:sudema_app/screens/home/servicos_carrossel.dart';
import 'package:sudema_app/screens/home/titulo_com_linha.dart';
import 'package:sudema_app/screens/home/noticias_carrossel.dart'; 

class HomeBody extends StatelessWidget {
  final List<Noticia> noticias;
  final VoidCallback onSelecionarDenuncia;
  final VoidCallback onSelecionarNoticias;
  final VoidCallback onSelecionarBalneabildiade;
  final VoidCallback onSelecionarContatos;

  const HomeBody({
    super.key,
    required this.noticias,
    required this.onSelecionarDenuncia,
    required this.onSelecionarNoticias,
    required this.onSelecionarBalneabildiade,
    required this.onSelecionarContatos
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
            BannerCarrossel(
              onTapDenuncia: onSelecionarDenuncia,
            ),
            SizedBox(height: screenHeight * 0.03),
            const TituloComLinha(titulo: 'Nossos serviços'),
            SizedBox(height: screenHeight * 0.02),
            ServicosCarrossel(
              onSelecionar: (key) {
                if (key == 'balneabilidade') {
                  onSelecionarBalneabildiade();
                } else if (key == 'denuncias') {
                  onSelecionarDenuncia();
                }
              },
            ),
            SizedBox(height: screenHeight * 0.015),
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
    return  NoticiasCarrossel(noticias: noticias);
  }
}
