import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/drawer.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/navbar.dart';

class EditarEmail extends StatefulWidget {
  const EditarEmail({super.key});

  @override
  State<EditarEmail> createState() => _EditarEmailState();
}

class _EditarEmailState extends State<EditarEmail> {
  bool _obscureText = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Alterar e-mail'),
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Senha', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
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
          const SizedBox(height: 24),
          const Text('Novo e-mail', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Confirmar o Novo e-mail', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
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
                padding:
                const EdgeInsets.symmetric(vertical: 22, horizontal: 128),
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
