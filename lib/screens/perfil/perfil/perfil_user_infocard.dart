import 'package:flutter/material.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_info_label.dart';
import 'package:sudema_app/screens/perfil/perfil/utils/perfil_utils.dart';

class PerfilInfoCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PerfilInfoCard({required this.userData, super.key});

  @override
  Widget build(BuildContext context) {
    String telefone = userData['phone'] ?? '';
    String cpf = userData['cpf'] ?? '';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  userData['name'] ?? 'Nome não encontrado',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3,
              height: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledInfoItem(
                    label: 'E-mail',
                    value: userData['email'] ?? 'E-mail não encontrado',
                  ),
                  const SizedBox(height: 8),
                  LabeledInfoItem(
                    label: 'Telefone',
                    value: formatarTelefone(telefone),
                  ),
                  const SizedBox(height: 8),
                  LabeledInfoItem(
                    label: 'CPF',
                    value: formatarCpf(cpf),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
