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

  const HomeBody({
    super.key,
    required this.noticias,
    required this.onSelecionarDenuncia,
    required this.onSelecionarNoticias,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            BannerDenuncia(
              onTap: onSelecionarDenuncia,
              screenWidth: screenWidth,
            ),
            const SizedBox(height: 24),
            const TituloComLinha(titulo: 'Nossos serviços'),
            const SizedBox(height: 20),
            
            ServicosCarrossel(
              onSelecionar: (label) {
                if (label == 'Balneabilidade') {
                  onSelecionarNoticias(); 
                } else if (label == 'Denuncias') {
                  onSelecionarDenuncia();
                }
              },
            ),
            const SizedBox(height: 24),
            TituloComLinha(
              titulo: 'Últimas notícias',
              verTodas: true,
              onVerTodas: onSelecionarNoticias,
              ),
            const SizedBox(height: 20),
            _buildNoticias(context),
          ],
        ),
      ),
    );
  }
  Widget _buildNoticias(BuildContext context) {
    return SizedBox(
      height: 340,
      child: noticias.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return NoticiaCard(noticia: noticia);
              },
            ),
    );
  }
}
