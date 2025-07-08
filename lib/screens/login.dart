import 'package:flutter/material.dart';
import 'package:sudema_app/screens/RecuperacaoSenha.dart';
import 'package:sudema_app/screens/home_screen.dart';
import 'package:sudema_app/screens/registerUser/RegistroUser.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:sudema_app/services/controllerLogin.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/screens/widgets/appbardenuncia.dart';
import 'reativar_conta.dart';
import '../screens/registerUser/confirmarRegistro.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? voltarPara;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _checkboxValue = false;
  bool _obscureText = true;
  String? _token;

  Future<void> _obterESalvarDeviceToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('deviceToken', fcmToken);
        print('Device Token salvo no SharedPreferences: $fcmToken');
      } else {
        print('Não foi possível obter o deviceToken do Firebase Messaging');
      }
    } catch (e) {
      print('Erro ao obter deviceToken: $e');
    }
  }

  Future<Map<String, dynamic>?> obterInformacoesUsuario() async {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token não encontrado!')),
      );
      return null;
    }

    try {
      final data = await AuthController.obterInformacoesUsuario(_token!);

      if (data != null) {
        print('Dados do usuário: $data');
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao buscar dados do usuário')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter informações do usuário: $e')),
      );
    }

    return null;
  }

  Future<void> realizarLogin() async {
    final email = emailController.text.trim();
    final senha = passwordController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    try {
      final resultado = await LoginController.realizarLogin(email, senha);

      if (resultado['success']) {
        final token = resultado['data']['token'];
        setState(() {
          _token = token;
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        await _obterESalvarDeviceToken();

        final dadosUsuario = await obterInformacoesUsuario();

        if (dadosUsuario != null) {
          final destino = voltarPara;
          if (destino != null) {
            Navigator.pushReplacementNamed(context, destino);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  initialIndex: 0,
                  userInfo: dadosUsuario,
                ),
              ),
            );
          }
        }
      } else if (resultado['disabledUser'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReativarContaPage(email: email, senha: senha),
          ),
        );
      } else if (resultado['nonVerifiedUser'] == true || resultado['statusCode'] == 423) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => codigoRegistro(
              email: resultado['email'],
            ),
          ),
        );
      } else {
        Flushbar(
          title: 'Erro',
          message: 'E-mail ou senha inválidos. Verifique suas credenciais.',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red.shade600,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(10),
          margin: const EdgeInsets.all(8),
        ).show(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao realizar login: $e')),
      );
    }
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
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
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
                        value: _checkboxValue,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkboxValue = value ?? false;
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
                    onPressed: realizarLogin,
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
                /*SizedBox(height: 12,),*/
                /*Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        endIndent: 10,
                      ),
                    ),
                    const Text(
                      'ou',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: realizarLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(300, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.grey, width: 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon/googleicon.png',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Entrar com o Google',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),*/
                /*const SizedBox(height: 12),*/
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
