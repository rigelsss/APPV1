import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Perfiluser extends StatefulWidget {
  final String? token;

  const Perfiluser({super.key, this.token});

  @override
  _PerfiluserState createState() => _PerfiluserState();
}

class _PerfiluserState extends State<Perfiluser> {
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;
  bool _errorFetching = false;
  String _errorMessage = ''; // <- Guarda a mensagem do erro
  late String _token;

  @override
  void initState() {
    super.initState();
    _prepararToken();
  }

  void _prepararToken() {
    if (widget.token != null && widget.token!.isNotEmpty) {
      _token = widget.token!;

      // 🛡️ Nova validação de formato
      if (!_isValidJwtFormat(_token)) {
        setState(() {
          _errorFetching = true;
          _isLoading = false;
          _errorMessage = 'Token inválido.';
        });
        return;
      }

      // Validação de expiração
      if (JwtDecoder.isExpired(_token)) {
        setState(() {
          _errorFetching = true;
          _isLoading = false;
          _errorMessage = 'Token expirado.';
        });
        return;
      }
    } else {
      // Simulação de token para testes
      _token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiUmlnZWwgU2FsZXMiLCJlbWFpbCI6InJpZ2VsQGV4YW1wbGUuY29tIiwicGhvbmUiOiIoODMpIDk5OTk5LTk5OTkiLCJjcGYiOiIxMjMuNDU2Ljc4OS0wMCJ9.aoFANumU9ua_Fhire_kFq6do-wNI4rxDW5jlVCZ7c1Q';
    }

    _carregarDadosUsuario();
  }

  void _carregarDadosUsuario() {
    try {
      _userData = JwtDecoder.decode(_token);

    if (!_userData.containsKey('name') || _userData['name'] == null || _userData['name'].toString().isEmpty ||
        !_userData.containsKey('email') || _userData['email'] == null || _userData['email'].toString().isEmpty ||
        !_userData.containsKey('phone') || _userData['phone'] == null || _userData['phone'].toString().isEmpty ||
        !_userData.containsKey('cpf') || _userData['cpf'] == null || _userData['cpf'].toString().isEmpty) {
        throw FormatException('Campos obrigatórios no token estão ausentes.');
      }

      setState(() {
        _isLoading = false;
      });
    } on FormatException catch (e) {
      setState(() {
        _errorFetching = true;
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorFetching = true;
        _isLoading = false;
        _errorMessage = 'Erro ao decodificar o token.';
      });
    }
  }

  // 🛡️ Função para validar estrutura do token JWT
  bool _isValidJwtFormat(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return false;
    }
    try {
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decodedPayload = json.decode(payload);
      if (decodedPayload is! Map<String, dynamic>) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_errorFetching && _errorMessage.isNotEmpty) {
      // Mostra o AlertDialog assim que detectar erro
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
        content: Text("Token JWT com erro no Payload: $message"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Fecha também a página de perfil
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
