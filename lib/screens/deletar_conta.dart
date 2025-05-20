import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';

class DeletarContaPage extends StatefulWidget {
  final String userId;

  const DeletarContaPage({super.key, required this.userId});

  @override
  State<DeletarContaPage> createState() => _DeletarContaPageState();
}

class _DeletarContaPageState extends State<DeletarContaPage> {
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _desativarConta() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = '${dotenv.env['BASE_URL']}/usuarios/mobile/${widget.userId}/desativar';

    print('BASE_URL: ${dotenv.env['BASE_URL']}');
    print('userId: ${widget.userId}');  


    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 204) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        await Future.delayed(const Duration(milliseconds: 500));
        Flushbar(
          backgroundColor: const Color(0xFFD2FDE6),
          duration: const Duration(seconds: 4),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(12),
          margin: const EdgeInsets.all(8),
          messageText: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Conta desativada!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B8C00),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Para reativar, basta realizar login novamente.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B8C00),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ).show(context);
      }
    } else {
      Flushbar(
        title: 'Erro',
        message: 'Não foi possível desativar a conta.',
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red.shade600,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(8),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Deletar conta',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Image.asset(
              'assets/images/warning.png',
              height: 120,
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tem certeza que deseja desativar sua conta do sistema?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Para prosseguir, insira a sua senha',
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _senhaController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: 'Senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 2.0,
                    color: Colors.grey[200]!,
                  ),
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _desativarConta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF3C9C25), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(
                    color: Color(0xFF3C9C25),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFAC5A5A), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Color(0xFFAC5A5A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
