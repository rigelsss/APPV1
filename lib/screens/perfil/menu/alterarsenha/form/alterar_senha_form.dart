import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sudema_app/screens/perfil/menu/alterarsenha/controller/alterar_senha_controller.dart';
import 'package:sudema_app/screens/senhas/RecuperacaoSenha.dart';

class AlterarSenhaForm extends StatefulWidget {
  const AlterarSenhaForm({super.key});

  @override
  State<AlterarSenhaForm> createState() => _AlterarSenhaFormState();
}

class _AlterarSenhaFormState extends State<AlterarSenhaForm> {
  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _confirmarAlteracao() async {
    final mensagem = await AlterarSenhaController.alterarSenha(
      senhaAtual: _senhaAtualController.text.trim(),
      novaSenha: _novaSenhaController.text.trim(),
      confirmarSenha: _confirmarSenhaController.text.trim(),
    );

    if (mensagem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Senha atual', style: TextStyle(fontSize: 16)),
      const SizedBox(height: 8),
      TextField(
        controller: _senhaAtualController,
        obscureText: _obscureCurrent,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureCurrent ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureCurrent = !_obscureCurrent;
              });
            },
          ),
        ),
      ),
      const SizedBox(height: 24),
      const Text('Nova senha', style: TextStyle(fontSize: 16)),
      const SizedBox(height: 8),
      TextField(
        controller: _novaSenhaController,
        obscureText: _obscureNew,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNew ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureNew = !_obscureNew;
              });
            },
          ),
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'A senha deve ter no mínimo 8 caracteres e deve conter letras, números e caracteres especiais',
        style: TextStyle(color: Color(0xFF747474)),
      ),
      const SizedBox(height: 24),
      const Text('Confirme a nova senha', style: TextStyle(fontSize: 16)),
      const SizedBox(height: 8),
      TextField(
        controller: _confirmarSenhaController,
        obscureText: _obscureConfirm,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirm ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirm = !_obscureConfirm;
              });
            },
          ),
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _confirmarAlteracao,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B8C00),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Confirmar alteração de senha',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Esqueceu a senha atual? ',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              TextSpan(
                text: ' Recuperar',
                style: const TextStyle(
                    color: Color(0xFF2A2F8C),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecuperacaoSenha(),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
