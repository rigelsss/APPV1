import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/drawer.dart';
import 'widgets/appbar.dart';
import 'widgets/navbar.dart';

class Contatos extends StatefulWidget {
  const Contatos({super.key});

  @override
  State<Contatos> createState() => _ContatosState();
}

Future<void> _abrirSite() async {
  final Uri url = Uri.parse('https://sudema.pb.gov.br/contatos');

  try {
    final bool launched = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
        throw 'Não foi possível abrir o site.';
      }
    }
  } catch (e) {
    print('Erro ao tentar abrir o site: $e');
  }
}


class _ContatosState extends State<Contatos> {
  int _currentIndex = 0;

  void _onNavBarTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/denuncias');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/balneabilidade');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/noticias');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contatos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Horário de funcionamento da SUDEMA:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.access_time, color: Colors.black54),
                        SizedBox(width: 10),
                        Text(
                          '08h às 12:00  /  13:30 ás 16:00',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),
                  Text('Telefone para denúncias:', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone_in_talk_outlined),
                        SizedBox(width: 10),
                        Text('+55 (83) 3690-1965', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),
                  Text('Telefone para contato SUDEMA:', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone_in_talk_outlined),
                        SizedBox(width: 10),
                        Text('+55 (83) 3218-5606', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: GestureDetector(
                      onTap: _abrirSite,
                      child: const Text(
                        'Lista completa de telefones para contato.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2A2F8C),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  Center(
                    child: Text(
                      'O atendimento presencial requer agendamento prévio',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final Uri url = Uri.parse('https://sigma.pb.gov.br/saap/src/empreendedor/');
                        try {
                          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                            if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                              throw 'Não foi possível abrir o site.';
                            }
                          }
                        } catch (e) {
                          print('Erro ao abrir o site: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2A2F8C),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Acessar sistema de agendamento (SAAP)',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Superintendência de Administração do Meio Ambiente - SUDEMA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Av. Monsenhor Walfredo Leal, 181 - Tambiá - João Pessoa - PB',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'CEP 58.020-540 - CGC 08.329.849/0001-15',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
