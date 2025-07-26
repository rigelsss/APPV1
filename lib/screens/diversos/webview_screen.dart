/// WEBVIEW_SCREEN
///
/// Responsável por: Exibir conteúdo web externo dentro do aplicativo SUDEMA.
/// Utilizado em: Visualização de notícias completas, documentos oficiais e links externos.
/// 
/// Esta tela utiliza WebView para carregar conteúdo web sem sair do aplicativo,
/// mantendo a experiência do usuário integrada. Especialmente útil para:
/// - Notícias completas da SUDEMA
/// - Documentos do Diário Oficial (DOE-PB)
/// - Links para sites institucionais

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url; // URL do conteúdo a ser carregado na WebView

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // Controlador da WebView para gerenciar o conteúdo web
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Configura o controlador da WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Permite JavaScript
      ..loadRequest(Uri.parse(widget.url)); // Carrega a URL fornecida
  }

  /// Widget WebViewScreen
  ///
  /// Descrição: Interface para exibição de conteúdo web dentro do app.
  /// Contém AppBar com título fixo e WebView ocupando o corpo da tela.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título fixo para documentos do Diário Oficial
        // TODO: Tornar dinâmico baseado no conteúdo carregado
        title: const Text('DOE-PB 26/03/2024'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      // WebView ocupa todo o corpo da tela
      body: WebViewWidget(controller: _controller),
    );
  }
}
