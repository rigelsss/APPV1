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
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Não foi possível abrir o site.';
  }
}


class _ContatosState extends State<Contatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      drawer: CustomDrawer(),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contato',
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
                  Text('Telefone para denúncias:', style: TextStyle(fontSize: 16),),
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
                        SizedBox(width: 10,),
                        Text('+55 (83) 3690-1965', style: TextStyle(fontSize: 18),)
                      ],
                    ),
                  ),
                  SizedBox(height: 28,),
                  Text('Telefone para contato SUDEMA:', style: TextStyle(fontSize: 16,),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone_in_talk_outlined),
                        SizedBox(width: 10,),
                        Text('+55 (83) 3690-1965', style: TextStyle(fontSize: 18),)
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
                  SizedBox(height: 28,),
                  Center(
                    child: Text('O atendimento prensecial requer agendamento prévio', style: TextStyle(color: Colors.black),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final Uri url = Uri.parse('https://pub.dev/packages/url_launcher/install');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          throw 'Não foi possível abrir o site.';
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
