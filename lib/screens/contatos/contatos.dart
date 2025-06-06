import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
import 'contatos_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class Contatos extends StatefulWidget {
  const Contatos({super.key});

  @override
  State<Contatos> createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  late ContatosController controller;

  @override
  void initState() {
    super.initState();
    controller = ContatosController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      drawer: CustomDrawer(onItemSelected: (int) {}),
      backgroundColor: Colors.white,
      bottomNavigationBar: NavBar(
        currentIndex: controller.currentIndex,
        onTap: (index) {
          setState(() {
            controller.onNavBarTapped(index);
          });
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
              child: _buildContatosBody(),
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
        Text('Contatos', style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w500)),
        const SizedBox(height: 28),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  Widget _buildInfoBox({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
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
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(Icons.phone_in_talk_outlined),
          const SizedBox(width: 10),
          Flexible(child: Text(number, style: GoogleFonts.lato(fontSize: 16))),
        ],
      ),
    );
  }
}
