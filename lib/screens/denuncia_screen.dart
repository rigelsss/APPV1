import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sudema_app/services/denuncia_service.dart';
import 'package:sudema_app/screens/widgets/image_picker.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denunciaconcluida.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';

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
  XFile? _image;
  bool _confirmacao = false;
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
    final camposPreenchidos = [
      _dataController.text,
      _descricaoController.text,
      _referenciaController.text,
      _denunciadoController.text,
    ].every((campo) => campo.trim().isNotEmpty);

    final dataValida = _validarData(_dataController.text);
    setState(() {

    });

    return camposPreenchidos && _confirmacao && dataValida;
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
        ..imagemPath = _image?.path;

      final resultado = await DenunciaService.enviar(context, dados);

      if (resultado) {
        DenunciaData().limpar();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const conclusao_de_denuncia()),
        );
      } else {
        _mostrarErro(
            '❌ Erro inesperado: o envio falhou, mas sem detalhes do servidor.');
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

  Future<bool> _confirmarEnvioSemImagem() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Enviar sem imagem?'),
            content: const Text(
                'Você não selecionou uma imagem. Deseja continuar mesmo assim?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Continuar')),
            ],
          ),
        ) ??
        false;
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Data do ocorrido *', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _dataController,
                focusNode: _dataFocus,
                decoration: InputDecoration(
                  labelText: 'Data do ocorrido *',
                  hintText: 'dd/mm/aaaa',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  errorText: _exibirErroData && !_dataValida
                      ? 'Data inválida ou no futuro (formato: dd/mm/aaaa)'
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              Text('Descrição *', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _descricaoController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Descreva a infração...',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Text('Ponto de referência *', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _referenciaController,
                decoration: InputDecoration(
                  hintText: 'Nome, nome da empresa, documento',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Text('Informações do denunciado *', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _denunciadoController,
                decoration: InputDecoration(
                  hintText: 'Nome, nome da empresa, documento...',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ImagePickerWidget(
                onImagePicked: (file) => setState(() => _image = file),
                image: _image,
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
              Center(
                child: ElevatedButton.icon(
                  onPressed: _enviar,
                  label: const Text(
                    'Concluir denúncia',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  icon: const Icon(Icons.check, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 100,
                    ),
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
