import 'package:flutter/material.dart';
import '../screens/widgets_reutilizaveis/drawer.dart';
import '../screens/widgets_reutilizaveis/appbar.dart';
import '../models/noticia.dart';

class HomePage extends StatefulWidget {
  final List<Noticia> noticias;
  const HomePage({super.key, required this.noticias});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool userIsLoggedIn = false;

  void _simulateLogin() {
    setState(() {
      userIsLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isLoggedIn: userIsLoggedIn,
        onLoginTap: () {
          Navigator.pushNamed(context, '/login').then((_) {
            _simulateLogin();
          });
        },
        onNotificationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Você tem novas notificações')),
          );
        },
      ),
      drawer: const CustomDrawer(),
      body: buildHomeBody(context), // 👈 refatorado aqui
    );
  }

  // 👇 MÉTODO PRINCIPAL DA HOME
  Widget buildHomeBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSearchBar(screenWidth),
              const SizedBox(height: 20),
              _buildBannerDenuncia(screenWidth),
              const SizedBox(height: 24),
              _buildSecaoTituloComLinha('Nossos serviços'),
              const SizedBox(height: 20),
              _buildCarrosselServicos(screenWidth),
              const SizedBox(height: 24),
              _buildTituloNoticiasComVerTudo(screenWidth),
              const SizedBox(height: 20),
              _buildCarrosselNoticias(),
            ],
          ),
        ),
      ),
    );
  }

  // 👇 MÉTODOS AUXILIARES
  Widget _buildSearchBar(double width) {
    return Center(
      child: SizedBox(
        width: width * 0.9,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50),
          ),
          child: const TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search),
              hintText: 'Pesquisar...',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerDenuncia(double width) {
    return Center(
      child: SizedBox(
        width: width * 0.9,
        height: 100,
        child: InkWell(
          onTap: () {
            print('Banner de denúncia clicado!');
          },
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/denuncia_bg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Identificou uma infração ambiental?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Faça uma denúncia!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/megafone.png',
                      width: 64,
                      height: 64,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecaoTituloComLinha(String titulo) {
    return Row(
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildCarrosselServicos(double width) {
    return SizedBox(
      width: width * 0.9,
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildServiceCardComImagem(
              label: 'Balneabilidade',
              imagePath: 'assets/images/bauneabilidade.jpg'),
          _buildServiceCardComImagem(
              label: 'Fiscalização', imagePath: 'assets/images/fiscalizacao.jpg'),
          _buildServiceCardComImagem(
              label: 'Denúncias', imagePath: 'assets/images/denuncia.jpg'),
          _buildServiceCardComImagem(
              label: 'Educação Ambiental',
              imagePath: 'assets/images/educacao_ambiental.jpg'),
          _buildServiceCardComImagem(
              label: 'Licenciamento', imagePath: 'assets/images/licenciamento.jpg'),
        ],
      ),
    );
  }

  Widget _buildTituloNoticiasComVerTudo(double width) {
    return SizedBox(
      width: width * 0.9,
      child: Row(
        children: [
          const Text(
            'Últimas notícias',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              print('Ver todas as notícias clicado!');
            },
            child: const Text(
              'Ver tudo',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarrosselNoticias() {
    return SizedBox(
      height: 200,
      child: widget.noticias.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.noticias.length,
              itemBuilder: (context, index) {
                final noticia = widget.noticias[index];
                return _buildCardNoticia(noticia); // Certifique-se de ter esse método!
              },
            ),
    );
  }

  // ⛳ Esse método você já deve ter criado em outro lugar
  Widget _buildServiceCardComImagem({
    required String label,
    required String imagePath,
  }) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 70,
              width: 100,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ⛳ Certifique-se de ter isso ou adapte ao que você já tem
  Widget _buildCardNoticia(Noticia noticia) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(noticia.imagemUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black54],
          ),
        ),
        child: Text(
          noticia.titulo,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
