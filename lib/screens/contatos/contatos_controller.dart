import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContatosController {
  final BuildContext context;
  int currentIndex;

  ContatosController(this.context, {int? currentIndex})
      : currentIndex = currentIndex ?? -1; // -1 evita highlight no NavBar


  Future<void> abrirSiteSudema() async {
    final Uri url = Uri.parse('https://sudema.pb.gov.br/contatos');
    await _abrirUrl(url);
  }

  Future<void> abrirSAAP() async {
    final Uri url = Uri.parse('https://sigma.pb.gov.br/saap/src/empreendedor/');
    await _abrirUrl(url);
  }

  Future<void> _abrirUrl(Uri url) async {
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
          throw 'Não foi possível abrir o site.';
        }
      }
    } catch (e) {
      print('Erro ao tentar abrir o site: $e');
    }
  }

  void onNavBarTapped(int index) {
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

// Novo método para Drawer:
  void onDrawerItemSelected(int index) {
    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/denuncias');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/balneabilidade');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/noticias');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/contatos');
        break;
    }
  }
}
