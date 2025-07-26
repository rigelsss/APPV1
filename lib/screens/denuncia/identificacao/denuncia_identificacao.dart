/// DENUNCIA_IDENTIFICACAO
///
/// Responsável por: Gerenciar a etapa 1 do fluxo de denúncias - escolha de identificação.
/// Utilizado em: Primeira aba do processo de criação de denúncias ambientais.
/// 
/// Esta tela permite ao usuário escolher entre:
/// - Denúncia anônima (sem identificação)
/// - Denúncia identificada (com dados do usuário logado)
/// - Redirecionamento para login se usuário não estiver autenticado
/// 
/// Integra com IdentificacaoController para gerenciar estado de autenticação
/// e salvar escolha no modelo global DenunciaData.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/denuncia/identificacao/controller/identificacao_controller.dart';
import 'package:sudema_app/screens/denuncia/identificacao/widgets/identificacao_botoes.dart';
import 'package:sudema_app/screens/denuncia/identificacao/widgets/identificacao_mensagem.dart';

class Identificacao extends StatefulWidget {
  final VoidCallback onAvancar; // Callback para avançar para próxima etapa

  const Identificacao({super.key, required this.onAvancar});

  @override
  State<Identificacao> createState() => _IdentificacaoState();
}

class _IdentificacaoState extends State<Identificacao> {
  // Controlador que gerencia estado de autenticação e escolhas
  final controller = IdentificacaoController();

  @override
  void initState() {
    super.initState();
    // Verifica se usuário está logado ao inicializar
    controller.verificarLogin(() => setState(() {}));
  }

  /// Widget Identificacao
  ///
  /// Descrição: Interface da primeira etapa com escolha de identificação.
  /// Exibe diferentes widgets baseado no estado de autenticação.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(right: 16, left: 16.0, top: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título dinâmico baseado no estado de login
          controller.titulo(),
          const SizedBox(height: 24),
          
          // Exibe interface baseada no estado de autenticação
          controller.logado
              ? // Usuário logado: botões de escolha
              IdentificacaoBotoes(
                  anonimo: controller.anonimo,
                  onSelecionarAnonimo: () {
                    // Seleciona denúncia anônima e avança
                    controller.selecionarAnonimo();
                    widget.onAvancar();
                    setState(() {});
                  },
                  onSelecionarIdentificado: () {
                    // Seleciona denúncia identificada e avança
                    controller.selecionarIdentificado();
                    widget.onAvancar();
                    setState(() {});
                  },
                  usuarioEmail: controller.usuarioEmail,
                )
              : // Usuário não logado: mensagem para fazer login
              IdentificacaoMensagem(onLogin: () {
                  // Navega para login com argumento de retorno
                  Navigator.pushNamed(
                    context,
                    '/login',
                    arguments: {'voltarPara': '/denuncia'},
                  );
                }),
        ],
      ),
    );
  }
}
