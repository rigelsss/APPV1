import 'package:flutter/material.dart';
import 'package:sudema_app/models/denuncia_data.dart';

class IdentificacaoButtons extends StatelessWidget {
  final bool isLoggedIn;
  final String email;
  final VoidCallback onProsseguir;

  const IdentificacaoButtons({
    super.key,
    required this.isLoggedIn,
    required this.email,
    required this.onProsseguir,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Você acessou o sistema como: ',
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: email,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              DenunciaData().anonimo = false;
              onProsseguir();
            },
            label: const Text(
              'Prosseguir com Identificação',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2A2F8C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 128),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              DenunciaData().anonimo = true;
              onProsseguir();
            },
            label: const Text(
              'Prosseguir Anônimo',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Color(0xFF2A2F8C)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 128),
            ),
          ),
        ],
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        label: const Text(
          'Acessar Sistema',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2A2F8C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 128),
        ),
      );
    }
  }
}
