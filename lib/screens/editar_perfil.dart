import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'perfil_page.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  int _currentIndex = -1;

  String? token;
  String? id;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'\d')});
  final telMask = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'\d')});

  @override
  void initState() {
    super.initState();
    _recuperarUsuarioId();
  }

  Future<void> _recuperarUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && JwtDecoder.isExpired(token) == false) {
      final decodedToken = JwtDecoder.decode(token);
      setState(() {
        id = decodedToken['id'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Sessão expirada. Faça login novamente.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Widget buildLabeledField({
    required String label,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1.2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  bool validarCPF(String cpf) {
    final numericCpf = cpf.replaceAll(RegExp(r'\D'), '');
    if (numericCpf.length != 11 || RegExp(r'^(\d)\1{10}$').hasMatch(numericCpf)) return false;

    List<int> digits = numericCpf.split('').map(int.parse).toList();
    for (int j = 9; j < 11; j++) {
      int sum = 0;
      for (int i = 0; i < j; i++) {
        sum += digits[i] * ((j + 1) - i);
      }
      int expectedDigit = (sum * 10) % 11;
      if (expectedDigit == 10) expectedDigit = 0;
      if (digits[j] != expectedDigit) return false;
    }
    return true;
  }

  Future<void> _salvarDados() async {
    if (!_formKey.currentState!.validate()) return;

    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ URL da API não configurada')),
      );
      return;
    }

    final String id = this.id!;
    final String nome = _nomeController.text.trim();
    final String cpf = _cpfController.text.replaceAll(RegExp(r'\D'), '');
    final String telefone = _telefoneController.text.replaceAll(RegExp(r'\D'), '');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/usuarios/mobile/$id');
    final body = {
      'nome': nome,
      'telefone': telefone,
      'cpf': cpf,
      'userType': 'MOBILE',
    };

    debugPrint('📤 Enviando PUT para: $url');
    debugPrint('📦 Corpo da requisição: ${jsonEncode(body)}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Dados atualizados com sucesso')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Perfiluser(token: token)),
        );
      } else {
        debugPrint('❌ Erro ${response.statusCode}: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erro ao atualizar: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      debugPrint('❌ Erro ao enviar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Falha de conexão com o servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Editar perfil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
      ),
      body: id == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    buildLabeledField(
                      label: 'Nome completo',
                      controller: _nomeController,
                      validator: (value) {
                        if (value == null || value.trim().split(' ').length < 2) {
                          return 'Digite seu nome completo.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buildLabeledField(
                      label: 'CPF',
                      controller: _cpfController,
                      inputFormatters: [cpfMask],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || !validarCPF(value)) {
                          return 'CPF inválido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buildLabeledField(
                      label: 'Telefone para contato',
                      controller: _telefoneController,
                      inputFormatters: [telMask],
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
                        if (digits.length != 11) {
                          return 'Telefone inválido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _salvarDados,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B8C00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Salvar alterações',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        enabled: false,
        onTap: (_) {},
      ),
    );
  }
}
