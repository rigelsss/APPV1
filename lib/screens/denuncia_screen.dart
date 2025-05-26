import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sudema_app/services/denuncia_service.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denunciaconcluida.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

class DenunciaScreen extends StatefulWidget {
  @override
  _DenunciaScreenState createState() => _DenunciaScreenState();
}

class HttpExceptionWithStatus implements Exception {
  final int statusCode;
  final String message;

  HttpExceptionWithStatus(this.statusCode, this.message);

  @override
  String toString() => 'HttpExceptionWithStatus($statusCode): $message';
}

class _DenunciaScreenState extends State<DenunciaScreen> {
  List<XFile> _imagens = [];
  bool _confirmacao = false;
  // ignore: unused_field
  bool _enviando = false;

  final _dataController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _referenciaController = TextEditingController();
  final _denunciadoController = TextEditingController();
  final _dataFocus = FocusNode();

  bool _dataValida = true;
  bool _exibirErroData = false;
  bool _erroDescricao = false;
  bool _erroReferencia = false;
  bool _erroDenunciado = false;

  @override
  void initState() {
    super.initState();
    _dataFocus.addListener(() {
      if (!_dataFocus.hasFocus) {
        setState(() {
          _exibirErroData = true;
          _dataValida = _validarData(_dataController.text);
        });
      }
    });
    _garantirToken();
  }

  Future<void> _garantirToken() async {
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
          print('✅ Token recuperado na denúncia: ${dados.usuarioId}, ${dados.tokenUsuario}');
        }
      }
    }
  }

  @override
  void dispose() {
    _dataController.dispose();
    _descricaoController.dispose();
    _referenciaController.dispose();
    _denunciadoController.dispose();
    _dataFocus.dispose();
    super.dispose();
  }

  bool _validarData(String input) {
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

  bool _validateFields() {
    final descricaoValida = _descricaoController.text.trim().isNotEmpty;
    final referenciaValida = _referenciaController.text.trim().isNotEmpty;
    final denunciadoValido = _denunciadoController.text.trim().isNotEmpty;
    final dataValida = _validarData(_dataController.text);

    setState(() {
      _erroDescricao = !descricaoValida;
      _erroReferencia = !referenciaValida;
      _erroDenunciado = !denunciadoValido;
      _dataValida = dataValida;
      _exibirErroData = true;
    });

    return descricaoValida &&
        referenciaValida &&
        denunciadoValido &&
        dataValida &&
        _confirmacao;
  }

  Future<void> _enviar() async {
    if (!_validateFields()) {
      Flushbar(
        message: 'Preencha todos os campos obrigatórios corretamente e confirme a declaração.',
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: const Icon(Icons.cancel_outlined, color: Colors.white),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
      return;
    }

    try {
      final dados = DenunciaData()
        ..dataOcorrencia = _dataController.text
        ..descricao = _descricaoController.text
        ..referencia = _referenciaController.text
        ..informacaoDenunciado = _denunciadoController.text
        ..imagemPaths = _imagens.map((file) => file.path).toList();

      final resultado = await DenunciaService.enviar(context, dados);

      if (resultado) {
        DenunciaData().limpar();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const conclusao_de_denuncia()),
        );
      } else {
        _mostrarErro('❌ Erro inesperado: o envio falhou, mas sem detalhes do servidor.');
      }
    } catch (e, stack) {
      debugPrint('Erro ao enviar denúncia: $e');
      debugPrint('StackTrace: $stack');
      if (e is HttpExceptionWithStatus) {
        _mostrarErro('Erro ${e.statusCode}: ${e.message}');
      } else {
        _mostrarErro('Erro ao enviar denúncia: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dataController.text = DateFormat('dd/MM/yyyy').format(picked);
        _dataValida = true;
        _exibirErroData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dados = DenunciaData();
    final textoDireita = (dados.anonimo ?? false)
        ? 'Denúncia anônima'
        : (dados.usuarioEmail ?? '');

    return Scaffold(
      backgroundColor: Colors.white, // fundo branco do Scaffold
      body: SafeArea(
        child: Container(
          color: Colors.white, // fundo branco interno
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Denúncia',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        textoDireita,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Data do ocorrido *'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _dataController,
                    focusNode: _dataFocus,
                    readOnly: true,
                    decoration: _dataInputDecoration(),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Descrição *'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descricaoController,
                    maxLines: 4,
                    decoration: _inputDecoration(
                      'Descreva a infração identificada...',
                      _erroDescricao ? 'Descrição obrigatória.' : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Ponto de referência *'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _referenciaController,
                    decoration: _inputDecoration(
                      'Nome, nome da empresa, documento...',
                      _erroReferencia ? 'Campo obrigatório.' : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Informações do denunciado *'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _denunciadoController,
                    decoration: _inputDecoration(
                      'Nome, nome da empresa, documento...',
                      _erroDenunciado ? 'Campo obrigatório.' : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Adicionar arquivos'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final files = await picker.pickMultiImage();
                      if (files.isNotEmpty) {
                        setState(() => _imagens.addAll(files));
                      }
                    },
                    child: DottedBorderContainer(imagens: _imagens),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _confirmacao,
                        shape: const CircleBorder(),
                        onChanged: (value) {
                          setState(() => _confirmacao = value ?? false);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Declaro que as informações acima prestadas são verdadeiras, e assumo a inteira responsabilidade pelas mesmas.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _enviar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B8C00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Concluir denúncia',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String texto) =>
      Text(texto, style: const TextStyle(fontSize: 16));

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

  InputDecoration _dataInputDecoration() {
    final base = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color.fromARGB(255, 191, 191, 191), width: 1.5),
    );

    return InputDecoration(
      hintText: 'dd/mm/aaaa',
      hintStyle: const TextStyle(color: Color.fromARGB(255, 142, 142, 142)),
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: _selecionarData,
      ),
      errorText: _exibirErroData && !_dataValida ? 'Data inválida' : null,
      enabledBorder: base,
      focusedBorder: base,
      errorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: base.copyWith(borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    );
  }
}

class DottedBorderContainer extends StatelessWidget {
  final List<XFile> imagens;

  const DottedBorderContainer({super.key, required this.imagens});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: const Color.fromARGB(255, 191, 191, 191),
      strokeWidth: 1.5,
      dashPattern: [8, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(6),
      child: Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: imagens.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.upload_outlined, size: 32, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Clique para enviar', style: TextStyle(color: Colors.grey)),
                ],
              )
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: imagens.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return Image.file(
                    File(imagens[index].path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }
}
