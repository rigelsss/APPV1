import 'package:flutter/material.dart';
import 'package:sudema_app/screens/denuncia/identificacao/denuncia_identificacao.dart';
import 'package:sudema_app/screens/denuncia/denuncia/denuncia_screen.dart';
import 'package:sudema_app/screens/denuncia/localizacao/aba_localizacao.dart';
import 'package:sudema_app/screens/denuncia/categoria/widgets/categoria_content.dart';
import 'package:sudema_app/screens/denuncia/categoria/controller/categorias_controller.dart';
import 'package:sudema_app/screens/widgets/denuncia_top_bar.dart';

class NovaDenuncia extends StatefulWidget {
  const NovaDenuncia({super.key});

  @override
  State<NovaDenuncia> createState() => _NovaDenunciaState();
}

class _NovaDenunciaState extends State<NovaDenuncia> {
  final List<String> opcao = ['Identificação', 'Categoria', 'Localização', 'Denúncia'];
  final CategoriasController controller = CategoriasController();

  @override
  void initState() {
    super.initState();
    controller.init(() => setState(() {}));
  }

  void _aoSelecionarAba(int index) {
    if (!controller.podeIrParaAba(index)) {
      setState(() {
        controller.definirMensagemErro(index);
      });
      return;
    }
    setState(() {
      controller.selectedIndex = index;
      controller.mensagemErro = null;
    });
  }

  void _irParaCategoria() {
    setState(() {
      controller.selectedIndex = 1;
      controller.mensagemErro = null;
    });
  }

  void _irParaDenuncia() {
    setState(() {
      controller.selectedIndex = 3;
      controller.mensagemErro = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            DenunciaTopBar(
              opcoes: opcao,
              selectedIndex: controller.selectedIndex,
              podeIrParaAba: controller.podeIrParaAba,
              onSelecionar: _aoSelecionarAba,
            ),
            if (controller.mensagemErro != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  controller.mensagemErro!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Expanded(child: _buildConteudoSelecionado()),
          ],
        ),
      ),
    );
  }

  Widget _buildConteudoSelecionado() {
    switch (controller.selectedIndex) {
      case 0:
        return Identificacao(onAvancar: _irParaCategoria);
      case 1:
        return CategoriaContent(
          controller: controller,
          onAvancar: () => _aoSelecionarAba(2),
          onRebuild: () => setState(() {}),
        );
      case 2:
        return AbaLocalizacao(onEnderecoConfirmado: _irParaDenuncia);
      case 3:
        return DenunciaScreen();
      default:
        return const SizedBox();
    }
  }
}
