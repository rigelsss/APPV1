/// CONTATOSS
///
/// Responsável por: Exibir informações de contato da SUDEMA, incluindo horários de funcionamento,
/// telefones para denúncias e contato geral, além de links para sistemas externos.
/// Utilizado em: Acessível através do drawer lateral e fornece informações institucionais
/// essenciais para comunicação com a SUDEMA.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/screens/widgets/appbar.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/widgets/drawer.dart';
import 'package:sudema_app/screens/contatos/controler/controller_contatos.dart' as controller;

/// Widget Contatoss
///
/// Descrição: Tela principal de contatos da SUDEMA que apresenta informações institucionais
/// como horários de funcionamento, telefones de contato e links para sistemas externos.
class Contatoss extends StatefulWidget {
  const Contatoss({super.key});

  @override
  State<Contatoss> createState() => _ContatossState();
}

class _ContatossState extends State<Contatoss> {
  /// BUILD
  ///
  /// Descrição: Constrói a interface da tela de contatos com AppBar, NavBar, Drawer e conteúdo principal.
  /// Parâmetros: 
  /// - context: Contexto do widget para navegação e tema
  /// Retorno: Widget Scaffold com a estrutura completa da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar padrão com opção de login
      appBar: HomeAppBar(
        isLoggedIn: false,
        onLoginTap: () {
          Navigator.pushNamed(context, '/login');
        },
      ),
      // NavBar inferior com navegação para as principais seções do app
      // currentIndex: -1 indica que nenhuma aba está selecionada (tela externa)
      bottomNavigationBar: NavBar(
        currentIndex: -1,
        onTap: (index) {
          // Navegação para as principais seções do app SUDEMA
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
      // Drawer lateral com navegação para todas as seções do app
      drawer: CustomDrawer(
        onItemSelected: (index) {
          Navigator.pop(context); // Fecha o drawer antes de navegar
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
      // Layout responsivo que se adapta ao tamanho da tela
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determina se a tela é larga (tablet/desktop) para ajustar padding
          final isWide = constraints.maxWidth > 600;
          final paddingHorizontal = isWide ? constraints.maxWidth * 0.2 : 16.0;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TÍTULO: sempre alinhado à esquerda da tela, independente do tamanho
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

                // CONTEÚDO: com padding horizontal variável baseado no tamanho da tela
                // Em telas largas, adiciona mais padding lateral para melhor legibilidade
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

  /// _BUILDCONTATOSBODY
  ///
  /// Descrição: Constrói o conteúdo principal da tela de contatos com informações
  /// organizadas sobre horários, telefones e links externos.
  /// Retorno: Widget Column com todas as informações de contato da SUDEMA
  Widget _buildContatosBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seção 1: Horário de funcionamento da SUDEMA
        Text(
          'Horário de funcionamento da SUDEMA:',
          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 12),
        // Box com ícone de relógio e informações de horário
        _buildInfoBox(
          icon: Icons.access_time,
          title: 'Segunda a sexta-feira',
          subtitle: '08h às 12:00  |  13:30 às 16:00',
        ),
        const SizedBox(height: 28),
        // Seção 2: Telefone específico para denúncias ambientais
        Text(
          'Telefone para denúncias:',
          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 12),
        // Box com ícone de telefone e número para denúncias
        _buildPhoneBox('+55 (83) 3690-1965'),
        const SizedBox(height: 28),
        // Seção 3: Telefone geral da SUDEMA para contatos institucionais
        Text(
          'Telefone para contato SUDEMA:',
          style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 10),
        // Box com ícone de telefone e número geral da SUDEMA
        _buildPhoneBox('+55 (83) 3218-5606'),
        const SizedBox(height: 28),
        // Link para o site oficial da SUDEMA com lista completa de contatos
        // Abre o navegador externo para acessar https://sudema.pb.gov.br/contatos
        Center(
          child: GestureDetector(
            onTap: controller.abrirSiteSudema,
            child: Text(
              'Lista completa de telefones para contato.',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: const Color(0xFF2A2F8C), // Cor azul institucional da SUDEMA
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        // Seção 4: Informação sobre agendamento obrigatório para atendimento presencial
        Center(
          child: Text(
            'O atendimento presencial requer agendamento prévio',
            style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ),
        const SizedBox(height: 10),
        // Botão para acessar o Sistema de Agendamento de Atendimento Presencial (SAAP)
        // Abre o navegador externo para https://sigma.pb.gov.br/saap/src/empreendedor/
        Center(
          child: ElevatedButton(
            onPressed: controller.abrirSAAP,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2F8C), // Cor azul institucional
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
        // Seção 5: Informações institucionais completas da SUDEMA
        // Inclui nome oficial, endereço completo, CEP e CNPJ
        Center(
          child: Column(
            children: [
              // Nome oficial completo da instituição
              Text(
                'Superintendência de Administração do Meio Ambiente - SUDEMA',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              // Endereço completo da sede da SUDEMA em João Pessoa
              Text(
                'Av. Monsenhor Walfredo Leal, 181 - Tambiá - João Pessoa - PB',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              // CEP e CNPJ oficiais da SUDEMA
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

  /// _BUILDINFOBOX
  ///
  /// Descrição: Constrói um container estilizado com ícone e informações em duas linhas.
  /// Usado para exibir horários de funcionamento de forma visual e organizada.
  /// Parâmetros:
  /// - icon: Ícone a ser exibido à esquerda (ex: Icons.access_time)
  /// - title: Título principal (ex: "Segunda a sexta-feira")
  /// - subtitle: Informação complementar (ex: horários)
  /// Retorno: Widget Container com layout de ícone + texto
  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Fundo cinza claro
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

  /// _BUILDPHONEBOX
  ///
  /// Descrição: Constrói um container estilizado para exibir números de telefone
  /// com ícone de telefone e formatação consistente.
  /// Parâmetros:
  /// - number: Número de telefone formatado (ex: "+55 (83) 3690-1965")
  /// Retorno: Widget Container com ícone de telefone + número
  Widget _buildPhoneBox(String number) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Fundo cinza claro consistente
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Ícone de telefone padrão para todos os números
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
