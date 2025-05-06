import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/getnoticia.dart';
import '../models/noticia.dart';
import '../screens/widgets_reutilizaveis/appbar.dart';
import '../screens/praias.dart';
import '../screens/PageDenuncia.dart';
import '../screens/noticias.dart';
import '../screens/widgets_reutilizaveis/navbar.dart';
import '../screens/widgets_reutilizaveis/drawer.dart';

class HomeScreen extends StatefulWidget {
  final String? token;
  const HomeScreen({super.key, this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String? token;
  List<Noticia> _noticias = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    token = widget.token;
    _carregarNoticias();
  }

  List<Widget> get _pages => [
        buildHomeBody(),
      const DenunciaPage(),
      const PraiasPage(),
      const NoticiasPage(),

      ];

  bool get isLoggedIn {
    if (token == null) return false;
    try {
      return !JwtDecoder.isExpired(token!);
    } catch (e) {
      return false;
    }
  }

  void _carregarNoticias() async {
    try {
      final listaNoticias = await CarregarNoticias().buscarNoticias();
      setState(() {
        _noticias = listaNoticias;
      });
    } catch (e) {
      print('Erro ao carregar notícias: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        isLoggedIn: isLoggedIn,
        onLoginTap: () {
          Navigator.pushNamed(context, '/login').then((value) {
            if (value != null && value is String) {
              setState(() {
                token = value;
              });
            }
          });
        },
      ),
      drawer: CustomDrawer(token: token),
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget buildHomeBody() {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildBannerDenuncia(screenWidth),
              const SizedBox(height: 24),
              _buildTituloComLinha('Nossos serviços'),
              const SizedBox(height: 20),
              _buildServicos(screenWidth),
              const SizedBox(height: 24),
              _buildTituloComLinha('Últimas notícias', verTodas: true),
              const SizedBox(height: 20),
              _buildNoticias(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerDenuncia(double screenWidth) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth * 0.9,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = 3;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/denuncia_bg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: screenWidth * 0.25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(height: 10),
                          Text(
                            'Identificou uma infração ambiental?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Faça uma denúncia!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/megafone.png',
                      width: screenWidth * 0.14,
                      height: screenWidth * 0.14,
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

  Widget _buildTituloComLinha(String titulo, {bool verTodas = false}) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
          if (verTodas)
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: const Text(
                'Ver todas',
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

  Widget _buildServicos(double screenWidth) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth * 0.9,
        height: 130,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildServiceCardComImagem(
                label: 'Balneabilidade',
                imagePath: 'assets/images/bauneabilidade.jpg'),
            _buildServiceCardComImagem(
                label: 'Fiscalização',
                imagePath: 'assets/images/fiscalizacao.jpg'),
            _buildServiceCardComImagem(
                label: 'Denúncias', imagePath: 'assets/images/denuncia.jpg'),
            _buildServiceCardComImagem(
                label: 'Educação Ambiental',
                imagePath: 'assets/images/educacao_ambiental.jpg'),
            _buildServiceCardComImagem(
                label: 'Licenciamento',
                imagePath: 'assets/images/licenciamento.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticias() {
    return SizedBox(
      height: 340,
      child: _noticias.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _noticias.length,
              itemBuilder: (context, index) {
                final noticia = _noticias[index];
                return _buildCardNoticia(noticia);
              },
            ),
    );
  }

  static Widget _buildServiceCardComImagem({
    required String label,
    required String imagePath,
  }) {
    return InkWell(
      onTap: () {
        print('Serviço $label clicado!');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 80,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNoticia(Noticia noticia) {
    DateTime data =
        DateTime.tryParse(noticia.dataHoraPublicacao) ?? DateTime.now();
    String dataFormatada =
        "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
    String horaFormatada =
        "${data.hour.toString().padLeft(2, '0')}h${data.minute.toString().padLeft(2, '0')}";

    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              noticia.imagemUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              noticia.titulo,
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "$dataFormatada às $horaFormatada",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
