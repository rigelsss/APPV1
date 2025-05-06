import 'package:flutter/material.dart';
import 'package:sudema_app/screens/notificacoes.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/navbar.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfiluser extends StatefulWidget {
  final String? token;

  const Perfiluser({super.key, this.token});

  @override
  PerfiluserState createState() => PerfiluserState();
}

class PerfiluserState extends State<Perfiluser> {
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;
  bool _errorFetching = false;
  String _errorMessage = '';
  late String _token;

  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    _prepararToken();
  }

  void _prepararToken() {
    if (widget.token != null && widget.token!.isNotEmpty) {
      _token = widget.token!;
      _carregarDadosUsuario();
    } else {
      setState(() {
        _errorFetching = true;
        _isLoading = false;
        _errorMessage = 'Token inválido ou não fornecido.';
      });
    }
  }

  Future<void> _carregarDadosUsuario() async {
    try {
      final data = await AuthController.obterInformacoesUsuario(_token);

      if (data != null && data['user'] != null) {
        setState(() {
          _userData = data['user'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorFetching = true;
          _isLoading = false;
          _errorMessage = 'Informações do usuário não encontradas.';
        });
      }
    } catch (e) {
      setState(() {
        _errorFetching = true;
        _isLoading = false;
        _errorMessage = 'Erro ao buscar dados: $e';
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (_errorFetching && _errorMessage.isNotEmpty) {
      Future.delayed(Duration.zero, () => _showErrorDialog(context, _errorMessage));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        )
            : null,
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (_errorFetching) {
            return Center(child: Text('Erro ao carregar perfil: $_errorMessage'));
          } else if (_userData.isEmpty) {
            return const Center(child: Text('Nenhuma informação de usuário encontrada'));
          } else {
            return _buildPerfil(context);
          }
        },
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/denuncias');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/praias');
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }

  Widget _buildPerfil(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
                    _userData['name'] ?? 'Nome não encontrado',
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
                    _LabeledInfoItem(
                      label: 'E-mail',
                      value: _userData['email'] ?? 'E-mail não encontrado',
                    ),
                    const SizedBox(height: 8),
                    _LabeledInfoItem(
                      label: 'Telefone',
                      value: _userData['phone'] ?? 'Telefone não encontrado',
                    ),
                    const SizedBox(height: 8),
                    _LabeledInfoItem(
                      label: 'CPF',
                      value: _userData['cpf'] ?? 'CPF não encontrado',
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificacoesPage(token: _token),
                    ),
                  ),
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
                  onTap: () => Navigator.pushNamed(context, '/EditarEmail'),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
                const SizedBox(height: 10),
                _buildMenuItem(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Alterar Senha',
                  onTap: () => Navigator.pushNamed(context, '/EditarSenha'),
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
                  onPressed: _logout,
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
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text("Erro ao buscar dados do usuário: $message"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _LabeledInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _LabeledInfoItem({required this.label, required this.value});

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
