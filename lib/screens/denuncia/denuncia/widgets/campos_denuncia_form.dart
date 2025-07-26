/// CAMPOS_DENUNCIA_FORM
///
/// Responsável por: Widget com todos os campos obrigatórios do formulário de denúncia.
/// Utilizado em: Etapa final de preenchimento da denúncia.
/// 
/// Este widget contém:
/// - Campo de data com máscara e seletor de calendário
/// - Campo de descrição da infração (textarea)
/// - Campo de ponto de referência
/// - Campo de informações do denunciado
/// - Validação visual com mensagens de erro
/// - Integração com DenunciaController

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:sudema_app/screens/denuncia/denuncia/controller/denuncia_controller.dart';

class CamposDenunciaForm extends StatelessWidget {
  final DenunciaController controller; // Controlador com estado dos campos
  final VoidCallback onUpdate;         // Callback para atualizar interface pai

  const CamposDenunciaForm({
    super.key,
    required this.controller,
    required this.onUpdate,
  });

  /// Widget CamposDenunciaForm
  ///
  /// Descrição: Formulário completo com todos os campos obrigatórios da denúncia.
  /// Cada campo possui validação e feedback visual de erro.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo 1: Data da ocorrência
        Text('Data do ocorrido *', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller.dataController,
          focusNode: controller.dataFocus,
          keyboardType: TextInputType.number,
          inputFormatters: [MaskedInputFormatter('##/##/####')], // Máscara dd/mm/aaaa
          decoration: _dataInputDecoration(context), // Decoração especial com calendário
        ),
        const SizedBox(height: 24),
        
        // Campo 2: Descrição da infração
        Text('Descrição *', style: GoogleFonts.lato(fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller.descricaoController,
          maxLines: 4, // Campo de texto expandido
          decoration: _inputDecoration(
            'Descreva a infração identificada...',
            controller.erroDescricao ? 'Descrição obrigatória.' : null,
          ),
        ),
        const SizedBox(height: 24),
        
        // Campo 3: Ponto de referência
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
        
        // Campo 4: Informações do denunciado
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

  /// _inputDecoration
  ///
  /// Descrição: Cria decoração padrão para campos de texto com validação.
  /// Parâmetros:
  /// - hint: texto de placeholder
  /// - erro: mensagem de erro ou null
  /// Retorno: InputDecoration configurada
  InputDecoration _inputDecoration(String hint, String? erro) {
    final base = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color.fromARGB(255, 191, 191, 191), width: 1.5),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color.fromARGB(255, 142, 142, 142)),
      errorText: erro, // Exibe mensagem de erro se presente
      enabledBorder: base,
      focusedBorder: base,
      // Borda vermelha quando há erro
      errorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    );
  }

  /// _dataInputDecoration
  ///
  /// Descrição: Decoração especial para campo de data com ícone de calendário.
  /// Parâmetros:
  /// - context: contexto para abrir seletor de data
  /// Retorno: InputDecoration com ícone e validação de data
  InputDecoration _dataInputDecoration(BuildContext context) {
    final base = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color.fromARGB(255, 191, 191, 191), width: 1.5),
    );

    return InputDecoration(
      hintText: 'dd/mm/aaaa',
      hintStyle: const TextStyle(color: Color.fromARGB(255, 142, 142, 142)),
      // Ícone de calendário que abre DatePicker
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () {
          controller.selecionarData(context, onUpdate);
        },
      ),
      // Mensagens de erro específicas para data
      errorText: controller.exibirErroData && !controller.dataValida 
      ? (
        controller.dataForaDoIntervalo
        ? 'A data deve estar entre 01/01/2020 e hoje.'
        : 'Data em formato inválido.'
        )
        : null,
      enabledBorder: base,
      focusedBorder: base,
      errorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    );
  }
}
