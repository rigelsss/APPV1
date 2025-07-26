/// CONTROLLER_CONTATOS
///
/// Responsável por: Gerenciar a abertura de links externos relacionados aos contatos da SUDEMA,
/// incluindo o site oficial e o sistema de agendamento SAAP.
/// Utilizado em: Tela de contatos (contatoss.dart) para navegação externa.

import 'package:url_launcher/url_launcher.dart';

/// ABRIRSITESUDEMA
///
/// Descrição: Abre o site oficial da SUDEMA na página de contatos para exibir
/// a lista completa de telefones e informações de contato.
/// Retorno: Future<void> - Execução assíncrona da abertura do link
Future<void> abrirSiteSudema() async {
  final Uri url = Uri.parse('https://sudema.pb.gov.br/contatos');
  await _abrirUrl(url);
}

/// ABRIRSAAP
///
/// Descrição: Abre o Sistema de Agendamento de Atendimento Presencial (SAAP)
/// do governo da Paraíba para que o usuário possa agendar atendimento na SUDEMA.
/// Retorno: Future<void> - Execução assíncrona da abertura do link
Future<void> abrirSAAP() async {
  final Uri url = Uri.parse('https://sigma.pb.gov.br/saap/src/empreendedor/');
  await _abrirUrl(url);
}

/// _ABRIRURL (Método privado)
///
/// Descrição: Método auxiliar que tenta abrir uma URL no navegador externo.
/// Se falhar, tenta abrir em WebView interno. Inclui tratamento de erros.
/// Parâmetros:
/// - url: URI do link a ser aberto
/// Retorno: Future<void> - Execução assíncrona com tratamento de erro
Future<void> _abrirUrl(Uri url) async {
  try {
    // Tenta abrir no navegador externo primeiro (preferência do usuário)
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Se falhar, tenta abrir em WebView interno como fallback
      if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
        throw 'Não foi possível abrir o site.';
      }
    }
  } catch (e) {
    // Log do erro para debug, mas não interrompe o fluxo do app
    print('Erro ao tentar abrir o site: $e');
  }
}
