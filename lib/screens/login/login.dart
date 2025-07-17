import 'package:flutter/material.dart';
import 'package:sudema_app/screens/RecuperacaoSenha.dart';
import 'package:sudema_app/screens/home/home_screen.dart';
import 'package:sudema_app/screens/registerUser/RegistroUser.dart';
import 'package:sudema_app/screens/widgets/appbar_login.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'login_controller.dart';
import 'login_prefs_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  bool _manterConectado = false;
  String? _token;
  String? voltarPara;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final manter = await LoginPrefsService.getKeepLoggedIn();
    final token = await LoginPrefsService.getToken();

    setState(() {
      _manterConectado = manter;
      _token = token;
    });

    if (manter && token != null) {
      final dadosUsuario = await AuthController.obterInformacoesUsuario(token);
      if (dadosUsuario != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(initialIndex: 0, userInfo: dadosUsuario),
          ),
        );
      }
    }
  }

  void _realizarLogin() {
    final email = emailController.text.trim();
    final senha = passwordController.text.trim();

    LoginService.realizarLogin(
      context: context,
      email: email,
      senha: senha,
      manterConectado: _manterConectado,
      redirecionarPara: voltarPara,
      onTokenReceived: (token) {
        setState(() {
          _token = token;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && voltarPara == null) {
      voltarPara = args['voltarPara'] as String?;
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarDenuncia(title: 'Login'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 500 : screenWidth * 0.9,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 280 : 180,
                  ),
                  child: Image.asset('assets/images/logosimples.png'),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Digite seu e-mail',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Digite sua senha',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: const Offset(-14, 0),
                      child: Checkbox(
                        value: _manterConectado,
                        onChanged: (bool? value) {
                          setState(() {
                            _manterConectado = value ?? false;
                          });
                        },
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-20, 0),
                      child: const Text('Mantenha-me conectado'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Recuperacaoosenha(),
                          ),
                        );
                      },
                      child: const Text('Esqueceu a senha?', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _realizarLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2F8C),
                      minimumSize: const Size(300, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ainda não possui uma conta?',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistroUser(),
                          ),
                        );
                      },
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFF2A2F8C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
