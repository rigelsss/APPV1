import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/screens/RecuperacaoSenha.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/navbar.dart';

import '../services/AuthMe.dart';
import '../services/SenhaController.dart';

class EditarSenha extends StatefulWidget {
  const EditarSenha({super.key});

  @override
  State<EditarSenha> createState() => _EditarSenhaState();
}

class _EditarSenhaState extends State<EditarSenha> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  int _currentIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/denuncias');
        break;
      case 2:
        Navigator.pushNamed(context, '/praias');
        break;
      case 3:
        Navigator.pushNamed(context, '/noticias');
        break;
    }
  }

  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Alterar senha'),
        backgroundColor: Colors.white,
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                final senhaAtual = _senhaAtualController.text.trim();
                final novaSenha = _novaSenhaController.text.trim();
                final confirmarSenha = _confirmarSenhaController.text.trim();

                if (novaSenha != confirmarSenha) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('As senhas novas não coincidem')),
                  );
                  return;
                }

                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');

                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Token não encontrado. Faça login novamente.')),
                  );
                  return;
                }

                try {
                  final userInfo = await AuthController.obterInformacoesUsuario(token);
                  final userId = userInfo?['user']?['id'];

                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID de usuário não encontrado.')),
                    );
                    return;
                  }

                  final sucesso = await UsuarioController.alterarSenha(
                    userId: userId,
                    senhaAtual: senhaAtual,
                    novaSenha: novaSenha,
                  );

                  if (sucesso == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Senha alterada com sucesso!')),
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(sucesso)),
                    );
                  }

                } catch (e) {
                  print('Erro ao tentar alterar senha: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ocorreu um erro ao tentar alterar a senha: $e')),
                  );
                }
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Confirmar alteração',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B8C00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 22, horizontal: 128),
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
                            builder: (context) => Recuperacaoosenha(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
