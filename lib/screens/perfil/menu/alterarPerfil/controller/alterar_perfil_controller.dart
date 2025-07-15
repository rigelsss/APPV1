import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../service/editar_perfil_service.dart';



class EditarPerfilController {
  final BuildContext context;

  EditarPerfilController({required this.context});

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();

  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'\d')},
  );

  final telMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'\d')},
  );

  String? token;
  String? id;

  Future<void> recuperarUsuarioId(Function onSuccess) async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null && !JwtDecoder.isExpired(savedToken)) {
      final decodedToken = JwtDecoder.decode(savedToken);
      token = savedToken;
      id = decodedToken['id'];
      onSuccess(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Sessão expirada. Faça login novamente.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void preencherCamposIniciais({
    required String nome,
    required String telefone,
    required String cpf,
  }) {
    nomeController.text = nome;
    telefoneController.text = telMask.maskText(telefone.replaceAll(RegExp(r'\D'), ''));
    cpfController.text = cpfMask.maskText(cpf.replaceAll(RegExp(r'\D'), ''));
  }

  Future<void> salvarDados(VoidCallback onSuccess, VoidCallback onFailure) async {
    if (!formKey.currentState!.validate()) return;

    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ URL da API não configurada')),
      );
      return;
    }

    final nome = nomeController.text.trim();
    final cpf = cpfController.text.replaceAll(RegExp(r'\D'), '');
    final telefone = telefoneController.text.replaceAll(RegExp(r'\D'), '');

    final response = await UsuarioService.atualizarUsuario(
      id: id!,
      token: token!,
      dados: {
        'nome': nome,
        'telefone': telefone,
        'cpf': cpf,
        'userType': 'MOBILE',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Dados atualizados com sucesso')),
      );
      onSuccess();
    } else {
      debugPrint('❌ Erro ${response.statusCode}: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erro ao atualizar: ${response.statusCode} - ${response.body}'),
        ),
      );
      onFailure();
    }
  }

  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
  }
}
