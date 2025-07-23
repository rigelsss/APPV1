import 'package:flutter/material.dart';
import 'package:sudema_app/screens/senhas/RecuperacaoSenha.dart';
import 'package:sudema_app/screens/cadastro/cadastro_screen.dart';
import 'package:sudema_app/screens/login/controller/login_controller.dart';
import 'package:sudema_app/screens/widgets/appbar_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? voltarPara;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginScreenController _loginController = LoginScreenController();
  bool _checkboxValue = false;
  bool _obscureText = true;
  // ignore: unused_field
  String? _token;

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
                LayoutBuilder(
                  builder: (context, constraints) {
                    final largura = constraints.maxWidth;
                    final bool telaPequena = largura < 360;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.translate(
                              offset: const Offset(-4, 0),
                              child: Checkbox(
                                value: _checkboxValue,
                                activeColor: const Color(0xFF2A2F8C), 
                                onChanged: (bool? value) {
                                  setState(() {
                                    _checkboxValue = value ?? false;
                                  });
                                },
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(-4, 0),
                              child: Text(
                                'Mantenha-me conectado',
                                style: TextStyle(fontSize: telaPequena ? 11 : 14),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecuperacaoSenha(),
                                ),
                              );
                            },
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                fontSize: telaPequena ? 11 : 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final senha = passwordController.text.trim();

                      _loginController.realizarLogin(
                        context: context,
                        email: email,
                        senha: senha,
                        voltarPara: voltarPara,
                        onTokenReceived: (token) {
                          setState(() {
                            _token = token;
                          });
                        },
                        onUserDataReceived: (userData) {
                          print('Usuário autenticado: $userData');
                        },
                      );
                    },
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool telaPequena = constraints.maxWidth < 360;

                    return Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Ainda não possui uma conta?',
                          style: TextStyle(fontSize: telaPequena ? 14 : 16),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegistroUser(),
                              ),
                            );
                          },
                          child: Text(
                            'Cadastre-se',
                            style: TextStyle(
                              fontSize: telaPequena ? 14 : 16,
                              color: const Color(0xFF2A2F8C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
