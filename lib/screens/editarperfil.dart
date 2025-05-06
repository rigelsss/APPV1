import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/navbar.dart';

class editarperfil extends StatefulWidget {
  const editarperfil({super.key});

  @override
  State<editarperfil> createState() => _editarperfilState();
}

class _editarperfilState extends State<editarperfil> {
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
        title: const Text('Alterar Perfil'),
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Nome completo', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          const Text('CPF', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Telefone para contato', style: TextStyle(fontSize: 16)),
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
                'Salvar alterações',
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
