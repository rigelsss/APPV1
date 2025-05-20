import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sudema_app/screens/DenunciaConcluida.dart';

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      }
    });
  }

  bool _validateFields() {
    return _dataController.text.isNotEmpty &&
        _descricaoController.text.isNotEmpty &&
        _referenciaController.text.isNotEmpty &&
        _denunciadoController.text.isNotEmpty &&
        _confirmacao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Data do ocorrido', style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),
              TextField(
                controller: _dataController,
                decoration: InputDecoration(
                  labelText: 'Data do ocorrido *',
                  hintText: 'dd/mm/aaaa',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 18),
              Text('Descrição', style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição *',
                  hintText: 'Descreva a infração identificada...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 18),
              Text('Ponto de referência', style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),
              TextField(
                controller: _referenciaController,
                decoration: InputDecoration(
                  labelText: 'Ponto de referência *',
                  hintText: 'Nome, nome da empresa, documento...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 18),
              Text('Informações do denunciado', style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),
              TextField(
                controller: _denunciadoController,
                decoration: InputDecoration(
                  labelText: 'Informações do denunciado *',
                  hintText: 'Nome, nome da empresa, documento...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: _image == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload, color: Colors.grey, size: 30),
                        SizedBox(height: 8),
                        Text(
                          'Clique para enviar',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                        : Image.file(
                      File(_image!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                value: _confirmacao,
                onChanged: (bool? value) {
                  setState(() {
                    _confirmacao = value ?? false;
                  });
                },
                title: Text(
                  'Declaro que as informações acima prestadas são verdadeiras, e assumo a inteira responsabilidade pelas mesmas.',
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _validateFields()
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => conclusao_de_denuncia(),
                      ),
                    );
                  }
                      : null,
                  label: const Text(
                    'Concluir denúncia',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 64),
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
