import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olá, Raiza'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card com nome
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Raiza Tomazoni',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                    children: const [
                      _LabeledInfoItem(
                        label: 'E-mail',
                        value: 'raiza@gmail.com',
                      ),
                      SizedBox(height: 8),
                      _LabeledInfoItem(
                        label: 'Telefone',
                        value: '+55 (83) 99648-8531',
                      ),
                      SizedBox(height: 8),
                      _LabeledInfoItem(
                        label: 'CPF',
                        value: '068.242.244-48',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.notifications_none,
                    title: 'Notificações',
                    onTap: () => Navigator.pushNamed(context, '/notificacoes'),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    context,
                    icon: Icons.edit,
                    title: 'Editar Perfil',
                    onTap: () => Navigator.pushNamed(context, '/editar-perfil'),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    context,
                    icon: Icons.email_outlined,
                    title: 'Alterar E-mail',
                    onTap: () => Navigator.pushNamed(context, '/alterar-email'),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
                  const SizedBox(height: 10),
                  _buildMenuItem(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Alterar Senha',
                    onTap: () => Navigator.pushNamed(context, '/alterar-senha'),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
                ],
              ),
            ),

            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // ação de sair
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Sair',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2F8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    // ação de deletar conta
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Deletar Conta',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// Widget reutilizável para info com rótulo
class _LabeledInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _LabeledInfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
