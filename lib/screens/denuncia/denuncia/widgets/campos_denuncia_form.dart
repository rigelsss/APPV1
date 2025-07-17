import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:sudema_app/screens/denuncia/denuncia/controller/denuncia_controller.dart';

class CamposDenunciaForm extends StatelessWidget {
  final DenunciaController controller;
  final VoidCallback onUpdate;

  const CamposDenunciaForm({
    super.key,
    required this.controller,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data do ocorrido *', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller.dataController,
          focusNode: controller.dataFocus,
          keyboardType: TextInputType.number,
          inputFormatters: [MaskedInputFormatter('##/##/####')],
          decoration: _dataInputDecoration(context),
        ),
        const SizedBox(height: 24),
        Text('Descrição *', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller.descricaoController,
          maxLines: 4,
          decoration: _inputDecoration(
            'Descreva a infração identificada...',
            controller.erroDescricao ? 'Descrição obrigatória.' : null,
          ),
        ),
        const SizedBox(height: 24),
        Text('Ponto de referência *', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller.referenciaController,
          decoration: _inputDecoration(
            'Nome, nome da empresa, documento...',
            controller.erroReferencia ? 'Campo obrigatório.' : null,
          ),
        ),
        const SizedBox(height: 24),
        Text('Informações do denunciado *', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller.denunciadoController,
          decoration: _inputDecoration(
            'Nome, nome da empresa, documento...',
            controller.erroDenunciado ? 'Campo obrigatório.' : null,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, String? erro) {
    final base = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color.fromARGB(255, 191, 191, 191), width: 1.5),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color.fromARGB(255, 142, 142, 142)),
      errorText: erro,
      enabledBorder: base,
      focusedBorder: base,
      errorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    );
  }

  InputDecoration _dataInputDecoration(BuildContext context) {
    final base = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color.fromARGB(255, 191, 191, 191), width: 1.5),
    );

    return InputDecoration(
      hintText: 'dd/mm/aaaa',
      hintStyle: const TextStyle(color: Color.fromARGB(255, 142, 142, 142)),
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () {
          controller.selecionarData(context, onUpdate);
        },
      ),
      errorText: controller.exibirErroData && !controller.dataValida ? 'Data inválida' : null,
      enabledBorder: base,
      focusedBorder: base,
      errorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    );
  }
}
