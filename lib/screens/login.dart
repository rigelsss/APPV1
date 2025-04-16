import 'package:flutter/material.dart';
import 'package:sudema_app/screens/Recupera%C3%A7%C3%A3oSenha.dart';
import 'package:sudema_app/screens/registro.dart';
import '../screens/widgets_reutilizaveis/appbardenuncia.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDenuncia(title: 'Login'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  constraints: const BoxConstraints(maxWidth: 280, maxHeight: 60),
                  child: Image.asset('assets/images/logo_sudema.webp'),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Digite seu e-mail',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login ainda não implementado')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2F8C),
                      minimumSize: const Size(300, 60),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _checkboxValue,
                      onChanged: (bool? value) {
                        setState(() {
                          _checkboxValue = value ?? false;
                        });
                      },
                    ),
                    const Text('Mantenha-me conectado'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Recuperacaoosenha()),
                        );
                      },
                      child: const Text('Esqueceu a senha?'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 1, endIndent: 10, color: Colors.black87),
                    ),
                    Text('ou', style: TextStyle(color: Colors.black87)),
                    Expanded(
                      child: Divider(thickness: 1, indent: 10, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(300, 60),
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.alternate_email, color: Colors.black87, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Login com Google',
                        style: TextStyle(color: Colors.black87, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ainda não possui uma conta?', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegistroPage()),
                        );
                      },
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(color: Color(0xFF2A2F8C), fontWeight: FontWeight.bold),
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
