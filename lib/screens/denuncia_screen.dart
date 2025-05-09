import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sudema_app/services/denuncia_service.dart';
import 'package:sudema_app/screens/widgets/image_picker.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denunciaconcluida.dart';
import 'package:intl/intl.dart';

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

  bool _dataValida = true;

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
    try {
      final data = DateFormat('dd/MM/yyyy').parseStrict(input);
      final agora = DateTime.now();
      return !data.isAfter(agora);
    } catch (_) {
      return false;
    }
  }

  Future<void> _enviar() async {
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
    }
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
                icon: Icons.calendar_today,
                erro: !_dataValida,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                'Descrição *',
                'Descreva a infração...',
                _descricaoController,
                maxLines: 4,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                'Ponto de referência *',
                'Ex: Empresa XYZ',
                _referenciaController,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                'Informações do denunciado *',
                'Nome, CPF...',
                _denunciadoController,
              ),
              const SizedBox(height: 12),
              ImagePickerWidget(
                onImagePicked: (file) => setState(() => _image = file),
                image: _image,
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _confirmacao,
                onChanged: (value) => setState(() => _confirmacao = value ?? false),
                title: const Text(
                  'Declaro que as informações acima prestadas são verdadeiras.',
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _validateFields() ? _enviar : null,
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    'Concluir denúncia',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 64,
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

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? icon,
    bool erro = false,
  }) {
    final isDataField = controller == _dataController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          onChanged: isDataField
              ? (value) {
                  setState(() {
                    _dataValida =
                        value.trim().isEmpty || _validarData(value);
                  });
                }
              : null,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            suffixIcon: icon != null ? Icon(icon) : null,
            border: const OutlineInputBorder(),
            errorText: isDataField &&
                    controller.text.trim().isNotEmpty &&
                    !_dataValida
                ? 'Data inválida ou no futuro (formato: dd/mm/aaaa)'
                : null,
          ),
          maxLines: maxLines,
        ),
      ],
    );
  }
}
