import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denuncia/denuncia/controller/denuncia_controller.dart';
import 'package:sudema_app/screens/denuncia/denuncia/widgets/upload_imagens.dart';
import 'package:sudema_app/screens/denuncia/denuncia/widgets/campos_denuncia_form.dart';
import 'package:sudema_app/screens/denuncia/denuncia/widgets/confirmacao_termos.dart';
import 'package:sudema_app/screens/denuncia/resumo/denuncia_resumo.dart';

class DenunciaScreen extends StatefulWidget {
  const DenunciaScreen({super.key});

  @override
  State<DenunciaScreen> createState() => _DenunciaScreenState();
}

class _DenunciaScreenState extends State<DenunciaScreen> {
  final controller = DenunciaController();

  @override
  void initState() {
    super.initState();
    controller.dataFocus.addListener(() {
      if (!controller.dataFocus.hasFocus) {
        setState(() {
          controller.exibirErroData = true;
          controller.dataValida = controller.validarData(controller.dataController.text);
        });
      }
    });
    controller.garantirToken();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _mostrarFlushErro() {
    Flushbar(
      message: 'Preencha todos os campos obrigatórios corretamente e confirme a declaração.',
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.cancel_outlined, color: Colors.white),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final dados = DenunciaData();
    final textoDireita = (dados.anonimo ?? false)
        ? 'Denúncia anônima'
        : (dados.usuarioEmail ?? '');

    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Denúncia', style: GoogleFonts.lato(fontSize: 24)),
                  ),
                  Text(
                    textoDireita,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CamposDenunciaForm(controller: controller, onUpdate: () => setState(() {})),
              const SizedBox(height: 24),
              Text('Adicionar arquivos', style: GoogleFonts.lato(fontSize: 16)),
              const SizedBox(height: 10),
              UploadImagensWidget(imagens: controller.imagens, onAdicionar: () async {
                await controller.adicionarImagens();
                setState(() {});
              }),
              const SizedBox(height: 24),
              ConfirmacaoTermos(
                confirmacao: controller.confirmacao,
                erroConfirmacao: controller.erroConfirmacao,
                onChanged: (value) {
                  setState(() {
                    controller.confirmacao = value;
                    controller.erroConfirmacao = false; 
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                onPressed: () {
                  final valido = controller.validarCampos();
                  setState(() {}); 

                  if (valido) {
                    controller.salvarEmDenunciaData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ResumoDenunciaScreen()),
                    );
                  } else {
                    _mostrarFlushErro();
                  }
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Revisar informações',
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
