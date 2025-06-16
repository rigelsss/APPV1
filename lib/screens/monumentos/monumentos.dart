import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/screens/widgets/appbar.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/widgets/drawer.dart';


class Monumentos extends StatefulWidget {
  const Monumentos({super.key});

  @override
  State<Monumentos> createState() => _MonumentosState();
}

class _MonumentosState extends State<Monumentos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        isLoggedIn: false,
        onLoginTap: () {
          Navigator.pushNamed(context, '/login');
        },
      ),
      bottomNavigationBar: NavBar(
        currentIndex: -1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/denuncias');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/praias');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/noticias');
          }
        },
      ),
      drawer: CustomDrawer(
        onItemSelected: (index) {
          Navigator.pop(context);
          switch (index) {
            case 1:
              Navigator.pushReplacementNamed(context, '/denuncias');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/praias');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/noticias');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/contatos');
              break;
          }
        },
      ),

      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final paddingHorizontal = isWide ? constraints.maxWidth * 0.2 : 16.0;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: 24,
              ),
              child: _buildMonumentosBody(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonumentosBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
        SizedBox(height: 8,),
        Text(
          'Monumento Natural Vale dos Dinossauros (MONA)',
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(height: 24),
        Text(
          'O Vale dos Dinossauros é uma unidade de conservação que fica localizada no sítio Passagem de Pedras, na cidade de Sousa, Sertão do Estado, e é reconhecido como um dos sítios paleontológicos mais importantes do mundo. O local possui uma grande bagagem histórica, com diversas marcas de dinossauros que remetem a aproximadamente 80 espécies que habitavam uma área de 704 quilômetros quadrados na Bacia do Rio do Peixe, no período pré-histórico.',
          style: GoogleFonts.lato(fontSize: 14),
        ),
        SizedBox(height: 20),
        Text(
          'No espaço, você encontra passarelas e mirantes que levam às trilhas formadas pelas pegadas e um museu com grande material de pesquisa paleontológica com informações das espécies que habitavam a região e fotos de achados.',
          style: GoogleFonts.lato(fontSize: 14),
        ),
        SizedBox(height: 20),
        Text(
          'Horário de funcionamento:',
          style: GoogleFonts.lato(fontSize: 14),
        ),
        SizedBox(height: 12),
        _buildInfoBox(
          icon: Icons.access_time,
          title: 'Terça a domingo',
          subtitle: '08:00 às 12:00  |  14:00 às 17:00',
        ),
        SizedBox(height: 20),
        Text(
          'Atividades:',
          style: GoogleFonts.lato(fontSize: 14),
        ),
        SizedBox(height: 12),
        _buildInfoBoxNoIcon(
          title: 'Museu e trilhas de pegadas',
          subtitle: 'Visitas guiadas às 9h, 10h, 11h, 15h e 16h',
        ),
      ],
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.lato(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text(subtitle, style: GoogleFonts.lato(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBoxNoIcon({
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.lato(fontSize: 16, color: Colors.black)),
          const SizedBox(height: 12),
          Text(subtitle, style: GoogleFonts.lato(fontSize: 16)),
        ],
      ),
    );
  }
}
