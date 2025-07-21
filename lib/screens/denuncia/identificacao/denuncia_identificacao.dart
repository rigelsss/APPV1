import 'package:flutter/material.dart';
import 'package:sudema_app/screens/denuncia/identificacao/controller/identificacao_controller.dart';
import 'package:sudema_app/screens/denuncia/identificacao/widgets/identificacao_botoes.dart';
import 'package:sudema_app/screens/denuncia/identificacao/widgets/identificacao_mensagem.dart';

class Identificacao extends StatefulWidget {
  final VoidCallback onAvancar;

  const Identificacao({super.key, required this.onAvancar});

  @override
  State<Identificacao> createState() => _IdentificacaoState();
}

class _IdentificacaoState extends State<Identificacao> {
  final controller = IdentificacaoController();

  @override
  void initState() {
    super.initState();
    controller.verificarLogin(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(right: 16, left: 16.0, top: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.titulo(),
          const SizedBox(height: 24),
          controller.logado
              ? IdentificacaoBotoes(
                  anonimo: controller.anonimo,
                  onSelecionarAnonimo: () {
                    controller.selecionarAnonimo();
                    widget.onAvancar();
                    setState(() {});
                  },
                  onSelecionarIdentificado: () {
                    controller.selecionarIdentificado();
                    widget.onAvancar();
                    setState(() {});
                  },
                  usuarioEmail: controller.usuarioEmail,
                )
              : IdentificacaoMensagem(onLogin: () {
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
