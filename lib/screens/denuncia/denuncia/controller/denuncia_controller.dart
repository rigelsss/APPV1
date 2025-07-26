/// DENUNCIA_CONTROLLER
///
/// Responsável por: Gerenciar estado e lógica da etapa final de denúncias.
/// Utilizado em: Controle da quarta etapa do fluxo de denúncias (preenchimento final).
/// 
/// Este controller gerencia:
/// - Controladores de texto para todos os campos do formulário
/// - Validação de campos obrigatórios e formato de data
/// - Upload e gerenciamento de imagens
/// - Confirmação de termos e condições
/// - Envio final da denúncia para a API
/// - Autenticação e recuperação de token

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:sudema_app/screens/denuncia/service/denuncia_service.dart';

class DenunciaController {
  // Controladores de texto para campos do formulário
  final dataController = TextEditingController();      // Data da ocorrência
  final descricaoController = TextEditingController(); // Descrição da infração
  final referenciaController = TextEditingController(); // Ponto de referência
  final denunciadoController = TextEditingController(); // Informações do denunciado
  final dataFocus = FocusNode();                       // Controle de foco do campo data

  // Dados da denúncia
  List<XFile> imagens = [];           // Lista de imagens selecionadas
  bool confirmacao = false;           // Estado do checkbox de termos
  bool erroConfirmacao = false;       // Erro de confirmação de termos
  bool enviando = false;              // Estado de envio da denúncia

  // Estados de validação dos campos
  bool dataValida = true;             // Validação do formato da data
  bool exibirErroData = false;        // Controle de exibição de erro de data
  bool erroDescricao = false;         // Erro no campo descrição
  bool erroReferencia = false;        // Erro no campo referência
  bool erroDenunciado = false;        // Erro no campo denunciado
  bool dataForaDoIntervalo = false;   // Data fora do intervalo permitido

  /// dispose
  ///
  /// Descrição: Libera recursos dos controladores e listeners.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Deve ser chamado quando o widget é descartado.
  void dispose() {
    dataController.dispose();
    descricaoController.dispose();
    referenciaController.dispose();
    denunciadoController.dispose();
    dataFocus.dispose();
  }

  /// garantirToken
  ///
  /// Descrição: Garante que token de autenticação está disponível para envio.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Recupera token do SharedPreferences se não estiver em DenunciaData.
  Future<void> garantirToken() async {
    final dados = DenunciaData();

    // Verifica se token já está disponível
    if (dados.tokenUsuario == null || dados.usuarioId == null) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        // Obtém informações do usuário a partir do token
        final info = await AuthController.obterInformacoesUsuario(token);
        if (info != null) {
          dados.usuarioId = info['id'];
          dados.tokenUsuario = token;
          dados.usuarioEmail = info['email'];
          debugPrint('Token recuperado na denúncia: ${dados.usuarioId}, ${dados.tokenUsuario}, ${dados.usuarioEmail}');
        }
      }
    }
  }

  bool validarData(String input) {
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    dataForaDoIntervalo = false;

    if (!regex.hasMatch(input)) return false;

    try {
      final data = DateFormat('dd/MM/yyyy').parseStrict(input);
      final agora = DateTime.now();
      final dataMinima = DateTime(2020, 1, 1);

      if (data.isBefore(dataMinima) || data.isAfter(agora)) {
        dataForaDoIntervalo = true;
        return false;
      }
      
      return true;

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
    firstDate: DateTime(2020),
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
