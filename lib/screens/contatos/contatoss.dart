import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/screens/widgets/appbar.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/widgets/drawer.dart';
import 'package:sudema_app/screens/contatos/controler/controller_contatos.dart' as controller;

class Contatoss extends StatefulWidget {
  const Contatoss({super.key});

  @override
  State<Contatoss> createState() => _ContatossState();
}

class _ContatossState extends State<Contatoss> {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TÍTULO: sempre alinhado à esquerda da tela
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: Text(
                    'Contatos',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // CONTEÚDO: com padding horizontal variável
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingHorizontal,
                    vertical: 4,
                  ),
                  child: _buildContatosBody(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContatosBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horário de funcionamento da SUDEMA:',
          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 12),
        _buildInfoBox(
          icon: Icons.access_time,
          title: 'Segunda a sexta-feira',
          subtitle: '08h às 12:00  |  13:30 às 16:00',
        ),
        const SizedBox(height: 28),
        Text(
          'Telefone para denúncias:',
          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 12),
        _buildPhoneBox('+55 (83) 3690-1965'),
        const SizedBox(height: 28),
        Text(
          'Telefone para contato SUDEMA:',
          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 10),
        _buildPhoneBox('+55 (83) 3218-5606'),
        const SizedBox(height: 28),
        Center(
          child: GestureDetector(
            onTap: controller.abrirSiteSudema,
            child: Text(
              'Lista completa de telefones para contato.',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: const Color(0xFF2A2F8C),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: Text(
            'O atendimento presencial requer agendamento prévio',
            style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: controller.abrirSAAP,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2F8C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Acessar sistema de agendamento (SAAP)',
              style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              Text(
                'Superintendência de Administração do Meio Ambiente - SUDEMA',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                'Av. Monsenhor Walfredo Leal, 181 - Tambiá - João Pessoa - PB',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                'CEP 58.020-540 - CGC 08.329.849/0001-15',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ],
          ),
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
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.lato(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneBox(String number) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.phone_in_talk_outlined),
          const SizedBox(width: 10),
          Flexible(
            child: Text(number, style: GoogleFonts.lato(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
