import 'package:flutter/material.dart';
import 'package:sudema_app/screens/login.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/appbardenuncia.dart';

class Novasenha extends StatefulWidget {
  const Novasenha({super.key});

  @override
  State<Novasenha> createState() => _NovasenhaState();
}

class _NovasenhaState extends State<Novasenha> {
  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarDenuncia(title: 'Crie uma nova Senha'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crie uma senha forte com, no mínimo, oito caracteres, contendo uma combinação de letras, números e símbolos.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text('Nova senha', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              obscureText: _obscureNovaSenha,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNovaSenha ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNovaSenha = !_obscureNovaSenha;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Confirmar a nova senha', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              obscureText: _obscureConfirmarSenha,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmarSenha ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmarSenha = !_obscureConfirmarSenha;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1B8C00),
                  padding: EdgeInsets.symmetric(horizontal: 160, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Redefinir',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
