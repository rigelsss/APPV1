import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/screens/widgets/appbar.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/widgets/drawer.dart';

class Jardim extends StatefulWidget {
  const Jardim({super.key});

  @override
  State<Jardim> createState() => _JardimState();
}

class _JardimState extends State<Jardim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              child: _buildJardimBody(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJardimBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jardim Botânico Benjamim Maranhão',
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(height: 24,),
        Text('O Jardim Botânico Benjamin Maranhão (JBBM) está localizado na Avenida Dom Pedro II, Bairro da Torre, João Pessoa-PB. Antes conhecido como Mata do Buraquinho, considerada um dos maiores remanescentes de Mata Atlântica natural em área urbana do Brasil.',
          style: GoogleFonts.lato(fontSize: 14),
        ),
        SizedBox(height: 20,),
        Text('A área possui cerca de 515ha, dos quais 343ha abrigam o Jardim Botânico, onde a flora revela-se sem timidez nas atividades recreativas e educativas promovidas no local.',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 24,),
        Text('Horário de funcionamento:',
          style: GoogleFonts.lato(fontSize: 14),),
        SizedBox(height: 12,),
        _buildInfoBox(
          icon: Icons.access_time,
          title: 'Terça a sábado',
          subtitle: '08:00 às 16:30',
        ),
        SizedBox(height: 24,),
        Text('Atividades',
          style: GoogleFonts.lato(fontSize: 14),
        ),
        SizedBox(height: 12,),
        _buildInfoBoxNoIcon(
          title: 'Trilhas guiadas às 9h e 14h',
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
        ],
      ),
    );
  }
}
