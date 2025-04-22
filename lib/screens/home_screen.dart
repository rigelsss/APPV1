import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  
import '../services/getnoticia.dart';
import '../models/noticia.dart';
import '../screens/widgets_reutilizaveis/appbar.dart';
import '../screens/praias.dart';
import '../screens/denuncia.dart';
import '../screens/noticias.dart';
import '../screens/widgets_reutilizaveis/navbar.dart';
import '../screens/widgets_reutilizaveis/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool userIsLoggedIn = false;
  List<Noticia> _noticias = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  List<Widget> get _pages => [
        buildHomeBody(),
        const PraiasPage(),
        const NoticiasPage(),
        const DenunciaPage(),
      ];

  void _simulateLogin() {
    setState(() {
      userIsLoggedIn = true;
    });
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
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 370,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DenunciaPage()),
                        );
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
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 370,
                  child: Row(
                    children: const [
                      Text(
                        'Nossos serviços',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 370,
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildServiceCardComImagem(
                        label: 'Balneabilidade',
                        imagePath: 'assets/images/bauneabilidade.jpg',
                      ),
                      _buildServiceCardComImagem(
                        label: 'Fiscalização',
                        imagePath: 'assets/images/fiscalizacao.jpg',
                      ),
                      _buildServiceCardComImagem(
                        label: 'Denúncias',
                        imagePath: 'assets/images/denuncia.jpg',
                      ),
                      _buildServiceCardComImagem(
                        label: 'Educação Ambiental',
                        imagePath: 'assets/images/educacao_ambiental.jpg',
                      ),
                      _buildServiceCardComImagem(
                        label: 'Licenciamento',
                        imagePath: 'assets/images/licenciamento.jpg',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 370,
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
                          'Ver todas',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildServiceCardComImagem({required String label, required String imagePath}) {
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
  DateTime data = DateTime.tryParse(noticia.dataHoraPublicacao) ?? DateTime.now();
  String dataFormatada = "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
  String horaFormatada = "${data.hour.toString().padLeft(2, '0')}h${data.minute.toString().padLeft(2, '0')}";

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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            noticia.imagemUrl,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$dataFormatada  $horaFormatada',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        //Comentário teste
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            noticia.titulo,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 15, // reduzido
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
        if (noticia.descricao.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              noticia.descricao,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13, // reduzido
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
          ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
}