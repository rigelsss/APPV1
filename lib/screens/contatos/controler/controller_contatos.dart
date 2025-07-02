import 'package:url_launcher/url_launcher.dart';

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
