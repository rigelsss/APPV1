import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sudema_app/services/denuncia_service.dart';
import 'package:sudema_app/screens/widgets/image_picker.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denunciaconcluida.dart';
import 'package:intl/intl.dart';
import 'package:sudema_app/services/AuthMe.dart';

class DenunciaScreen extends StatefulWidget {
  @override
  _DenunciaScreenState createState() => _DenunciaScreenState();
}

class _DenunciaScreenState extends State<DenunciaScreen> {
  XFile? _image;
  bool _confirmacao = false;

  final _dataController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _referenciaController = TextEditingController();
  final _denunciadoController = TextEditingController();

  final _dataFocus = FocusNode();

  bool _dataValida = true;
  bool _exibirErroData = false;

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

  bool _validateFields() {
    final camposPreenchidos = [
      _dataController.text,
      _descricaoController.text,
      _referenciaController.text,
      _denunciadoController.text,
    ].every((campo) => campo.trim().isNotEmpty);

    final dataValida = _validarData(_dataController.text);
    setState(() {
      _dataValida = dataValida;
    });

    return camposPreenchidos && _confirmacao && dataValida;
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

  Future<void> _enviar() async {
    try {
      final data = DenunciaData()
        ..dataOcorrencia = _dataController.text
        ..descricao = _descricaoController.text
        ..referencia = _referenciaController.text
        ..informacaoDenunciado = _denunciadoController.text
        ..imagemPath = _image?.path;

      final resultado = await DenunciaService.enviar(context, data);

      if (resultado) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const conclusao_de_denuncia()),
        );
      } else {
        _mostrarErro('Não foi possível enviar a denúncia. Tente novamente.');
      }
    } catch (e) {
      _mostrarErro('Erro inesperado: ${e.toString()}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Data do ocorrido', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _dataController,
                focusNode: _dataFocus,
                decoration: InputDecoration(
                  hintText: 'dd/mm/aaaa',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                  errorText: _exibirErroData && !_dataValida
                      ? 'Data inválida ou no futuro (formato: dd/mm/aaaa)'
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text('Descrição', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _descricaoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Descreva a infração...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Ponto de referencia', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _referenciaController,
                decoration: const InputDecoration(
                  hintText: 'Nome, nome da empresa, documento...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Informações do denunciado*', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _denunciadoController,
                decoration: const InputDecoration(
                  hintText: 'Nome, nome da empresa, documento...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Adicionar arquivos', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              ImagePickerWidget(
                onImagePicked: (file) => setState(() => _image = file),
                image: _image,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _confirmacao,
                    shape: const CircleBorder(),
                    onChanged: (bool? value) {
                      setState(() {
                        _confirmacao = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Declaro que as informações acima prestadas são verdadeiras, e assumo a inteira responsabilidade pelas mesmas.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _validateFields() ? _enviar : null,
                  label: const Text(
                    'Concluir denúncia',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 120,
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
