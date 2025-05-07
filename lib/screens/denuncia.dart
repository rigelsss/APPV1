import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sudema_app/screens/DenunciaConcluida.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:http_parser/http_parser.dart';
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

  void _mostrarErro(String mensagem) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensagem),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}


Future<void> _enviarDenuncia() async {
  final data = DenunciaData();

  // 1. Verifica se campos obrigatórios estão preenchidos
  if (data.tipoDenunciaId == null || int.tryParse(data.tipoDenunciaId!) == null) {
    _mostrarErro('Categoria da denúncia não foi selecionada corretamente.');
    return;
  }

  if (data.usuarioId == null || data.usuarioId!.isEmpty) {
    _mostrarErro('Usuário não identificado. Faça login novamente.');
    return;
  }

  if ([data.estado, data.bairro, data.municipio, data.logradouro].any((e) => e == null || e.isEmpty)) {
    _mostrarErro('Preencha todos os dados do endereço antes de enviar.');
    return;
  }

  // 2. Converte data para ISO 8601
  String dataOcorridoISO;
  try {
    final format = DateFormat('dd/MM/yyyy');
    final parsedDate = format.parse(_dataController.text);
    dataOcorridoISO = parsedDate.toIso8601String(); 
  } catch (_) {
    _mostrarErro('Data inválida. Use o formato dd/mm/aaaa');
    return;
  }

  // 3. Preenche dados
  data.dataOcorrencia = dataOcorridoISO;
  data.descricao = _descricaoController.text;
  data.referencia = _referenciaController.text;
  data.informacaoDenunciado = _denunciadoController.text;
  data.imagemPath = _image?.path;

  // 4. Cria requisição
  final url = Uri.parse('http://10.0.2.2:9000/api/v1/denuncias');
  final request = http.MultipartRequest('POST', url);

  if (data.tokenUsuario != null) {
    request.headers['Authorization'] = 'Bearer ${data.tokenUsuario}';
  }

  // 5. JSON de denúncia
  final denunciaJson = jsonEncode({
    "tipoDenunciaId": int.parse(data.tipoDenunciaId!),
    "usuarioId": data.usuarioId,
    "descricao": data.descricao,
    "informacaoDenunciado": data.informacaoDenunciado,
    "dataOcorrido": data.dataOcorrencia,
    "anonimo": data.anonimo ?? false,
  });

  // 6. JSON de endereço
  final enderecoJson = jsonEncode({
    "longitude": data.longitude,
    "latitude": data.latitude,
    "estado": data.estado,
    "bairro": data.bairro,
    "municipio": data.municipio,
    "logradouro": data.logradouro,
    "pontoReferencia": data.referencia,
  });

  // 7. Adiciona os arquivos JSON com content-type adequado
  request.files.add(http.MultipartFile.fromString(
    'denuncia',
    denunciaJson,
    contentType: MediaType('application', 'json'),
  ));

  request.files.add(http.MultipartFile.fromString(
    'endereco',
    enderecoJson,
    contentType: MediaType('application', 'json'),
  ));

  // 8. Adiciona imagem, se houver
  if (data.imagemPath != null && File(data.imagemPath!).existsSync()) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'anexos',
        data.imagemPath!,
        filename: data.imagemPath!.split('/').last,
        contentType: MediaType('image', 'jpeg'), // ou 'png' se for o caso
      ),
    );
  }

  // 9. Envia a requisição
  try {
    print('Denuncia JSON: $denunciaJson');
    print('Endereco JSON: $enderecoJson');
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('Status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const conclusao_de_denuncia()),
      );
    } else {
      _mostrarErro('Erro ao enviar denúncia (${response.statusCode}): $responseBody');
    }
  } catch (e) {
    _mostrarErro('Erro na requisição: $e');
  }
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
                              Text('Clique para enviar', style: TextStyle(color: Colors.grey)),
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
                  onPressed: _validateFields() ? _enviarDenuncia : null,
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
