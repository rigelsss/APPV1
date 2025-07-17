import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:sudema_app/screens/denuncia/service/denuncia_service.dart';

class DenunciaController {
  final dataController = TextEditingController();
  final descricaoController = TextEditingController();
  final referenciaController = TextEditingController();
  final denunciadoController = TextEditingController();
  final dataFocus = FocusNode();

  List<XFile> imagens = [];
  bool confirmacao = false;
  bool erroConfirmacao = false;
  bool enviando = false;

  bool dataValida = true;
  bool exibirErroData = false;
  bool erroDescricao = false;
  bool erroReferencia = false;
  bool erroDenunciado = false;

  void dispose() {
    dataController.dispose();
    descricaoController.dispose();
    referenciaController.dispose();
    denunciadoController.dispose();
    dataFocus.dispose();
  }

  Future<void> garantirToken() async {
    final dados = DenunciaData();

    if (dados.tokenUsuario == null || dados.usuarioId == null) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final info = await AuthController.obterInformacoesUsuario(token);
        if (info != null) {
          dados.usuarioId = info['id'];
          dados.tokenUsuario = token;
          dados.usuarioEmail = info['email'];
          debugPrint('✅ Token recuperado na denúncia: ${dados.usuarioId}, ${dados.tokenUsuario}, ${dados.usuarioEmail}');
        }
      }
    }
  }

  bool validarData(String input) {
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(input)) return false;

    try {
      final data = DateFormat('dd/MM/yyyy').parseStrict(input);
      final agora = DateTime.now();
      return !data.isAfter(agora);
    } catch (_) {
      return false;
    }
  }

  bool validarCampos() {
    final descricaoValida = descricaoController.text.trim().isNotEmpty;
    final referenciaValida = referenciaController.text.trim().isNotEmpty;
    final denunciadoValido = denunciadoController.text.trim().isNotEmpty;
    final dataValidaCampo = validarData(dataController.text);

    erroDescricao = !descricaoValida;
    erroReferencia = !referenciaValida;
    erroDenunciado = !denunciadoValido;
    dataValida = dataValidaCampo;
    exibirErroData = true;
    erroConfirmacao = !confirmacao;

    return descricaoValida &&
        referenciaValida &&
        denunciadoValido &&
        dataValidaCampo &&
        confirmacao;
  }

  Future<bool> enviarFormulario(BuildContext context) async {
    final dados = DenunciaData()
      ..dataOcorrencia = dataController.text
      ..descricao = descricaoController.text
      ..referencia = referenciaController.text
      ..informacaoDenunciado = denunciadoController.text
      ..imagemPaths = imagens.map((file) => file.path).toList();

    try {
      final resultado = await DenunciaService.enviar(context, dados);
      if (resultado) {
        DenunciaData().limpar();
        return true;
      } else {
        throw Exception('❌ Erro inesperado: envio falhou sem detalhes do servidor.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> selecionarData(BuildContext context, VoidCallback onUpdate) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    locale: const Locale('pt', 'BR'),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2A2F8C), 
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: Colors.white,
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    dataController.text = DateFormat('dd/MM/yyyy').format(picked);
    dataValida = true;
    exibirErroData = false;
    onUpdate();
  }
}
  Future<void> adicionarImagens() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      imagens.addAll(files);
    }
  }
  void salvarEmDenunciaData() {
    DenunciaData()
      ..dataOcorrencia = dataController.text
      ..descricao = descricaoController.text
      ..referencia = referenciaController.text
      ..informacaoDenunciado = denunciadoController.text
      ..imagemPaths = imagens.map((file) => file.path).toList();
  }
}
