// denuncia_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sudema_app/services/denuncia_service.dart';
import 'package:sudema_app/screens/widgets/image_picker.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denunciaconcluida.dart';
import 'package:intl/intl.dart';
import 'dart:io';

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
    setState(() {
      _dataValida = _validarData(_dataController.text);
      _erroDescricao = _descricaoController.text.trim().isEmpty;
      _erroReferencia = _referenciaController.text.trim().isEmpty;
      _erroDenunciado = _denunciadoController.text.trim().isEmpty;
    });

    return !_erroDescricao &&
        !_erroReferencia &&
        !_erroDenunciado &&
        _dataValida &&
        _confirmacao;
  }

  Future<void> _enviar() async {
    if (!_validateFields()) {
      _mostrarErro('Preencha todos os campos obrigatórios.');
      return;
    }

    final dados = DenunciaData()
      ..dataOcorrencia = _dataController.text
      ..descricao = _descricaoController.text
      ..referencia = _referenciaController.text
      ..informacaoDenunciado = _denunciadoController.text
      ..imagemPath = _image?.path;

    if (dados.usuarioId == null || dados.tokenUsuario == null) {
      _mostrarErro('Usuário não identificado. Faça login novamente.');
      return;
    }

    if (dados.tipoDenunciaId == null) {
      _mostrarErro('Categoria da denúncia não selecionada.');
      return;
    }

    if ([dados.estado, dados.bairro, dados.municipio, dados.logradouro]
        .any((e) => e == null || e.isEmpty)) {
      _mostrarErro(
          'Endereço incompleto. Retorne à aba de localização e confirme o endereço.');
      return;
    }

    if (dados.imagemPath == null || !File(dados.imagemPath!).existsSync()) {
      final continuar = await _confirmarEnvioSemImagem();
      if (!continuar) return;
    }

    setState(() => _enviando = true);

    try {
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
              _buildTextField(
                'Data do ocorrido *',
                'dd/mm/aaaa',
                _dataController,
                focusNode: _dataFocus,
                icon: Icons.calendar_today,
                erro: _exibirErroData && !_dataValida,
                erroMsg: 'Data inválida ou no futuro (formato: dd/mm/aaaa)',
              ),
              const SizedBox(height: 18),
              _buildTextField(
                'Descrição *',
                'Descreva a infração...',
                _descricaoController,
                maxLines: 4,
                erro: _erroDescricao,
                erroMsg: 'O campo "Descrição" é obrigatório',
              ),
              const SizedBox(height: 18),
              _buildTextField(
                'Ponto de referência *',
                'Ex: Empresa XYZ',
                _referenciaController,
                erro: _erroReferencia,
                erroMsg: 'O campo "Ponto de Referencia" é obrigatório',
              ),
              const SizedBox(height: 18),
              _buildTextField(
                'Informações do denunciado *',
                'Nome, CPF...',
                _denunciadoController,
                erro: _erroDenunciado,
                erroMsg: 'Este campo é obrigatório',
              ),
              const SizedBox(height: 12),
              ImagePickerWidget(
                onImagePicked: (file) => setState(() => _image = file),
                image: _image,
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _confirmacao,
                onChanged: (value) =>
                    setState(() => _confirmacao = value ?? false),
                title: const Text(
                    'Declaro que as informações acima prestadas são verdadeiras.'),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _enviando ? null : _enviar,
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: _enviando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Concluir denúncia',
                          style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 22, horizontal: 64),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? icon,
    bool erro = false,
    String? erroMsg,
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            suffixIcon: icon != null ? Icon(icon) : null,
            border: const OutlineInputBorder(),
            errorText: erro ? erroMsg : null,
          ),
          maxLines: maxLines,
        ),
      ],
    );
  }
}
