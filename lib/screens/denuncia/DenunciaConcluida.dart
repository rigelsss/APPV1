/// DENUNCIA_CONCLUIDA
///
/// Responsável por: Exibir tela de confirmação após envio bem-sucedido de denúncia.
/// Utilizado em: Final do fluxo de denúncias, após envio para a API da SUDEMA.
/// 
/// Esta tela confirma ao usuário que sua denúncia foi enviada com sucesso
/// e oferece navegação de volta para a tela inicial. Inclui:
/// - Mensagem de sucesso com ícone verde
/// - Botão para retornar à página inicial
/// - Verificação de autenticação do usuário

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/screens/widgets/appbar.dart';
import 'package:sudema_app/screens/home/home_screen.dart';
import 'package:sudema_app/screens/login/login.dart';

class DenunciaConcluida extends StatefulWidget {
  const DenunciaConcluida({super.key});

  @override
  State<DenunciaConcluida> createState() => _DenunciaConcluida();
}

class _DenunciaConcluida extends State<DenunciaConcluida> {
  // Token JWT do usuário para verificação de autenticação
  String? _token;

  @override
  void initState() {
    super.initState();
    _carregarToken(); // Carrega token ao inicializar a tela
  }

  /// _carregarToken
  ///
  /// Descrição: Carrega o token JWT armazenado localmente.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Busca o token no SharedPreferences para verificar autenticação.
  Future<void> _carregarToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      setState(() {
        _token = token;
      });
    }
  }

  /// isLoggedIn
  ///
  /// Descrição: Verifica se o usuário está autenticado com token válido.
  /// Parâmetros: nenhum
  /// Retorno: bool - true se logado e token válido
  ///
  /// Valida se o token existe e não está expirado.
  bool get isLoggedIn {
    if (_token == null) return false;
    try {
      return !JwtDecoder.isExpired(_token!); // Verifica expiração do JWT
    } catch (_) {
      return false; // Token inválido
    }
  }

  /// Widget DenunciaConcluida
  ///
  /// Descrição: Interface de confirmação de denúncia enviada com sucesso.
  /// Contém mensagem de sucesso e botão para retornar à home.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar com estado de login dinâmico
      appBar: HomeAppBar(
        isLoggedIn: isLoggedIn,
        onLoginTap: () {
          // Navega para tela de login se não autenticado
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Layout responsivo para diferentes tamanhos de tela
          final isWide = constraints.maxWidth > 600;
          final horizontalPadding = isWide ? constraints.maxWidth * 0.2 : 16.0;
          final containerMaxWidth = isWide ? 400.0 : double.infinity;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título da seção
                  Text(
                    'Denúncias',
                    style: GoogleFonts.lato(fontSize: 24),
                  ),
                  const SizedBox(height: 30),
                  
                  // Container de sucesso centralizado
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: containerMaxWidth),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2FDE6), // Verde claro de sucesso
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // Conteúdo da mensagem de sucesso
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Ícone de sucesso
                            const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF1B8C00), // Verde SUDEMA
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            // Texto de confirmação responsivo
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, innerConstraints) {
                                  // Ajusta tamanho da fonte baseado na largura
                                  double fontSize = 18;
                                  if (innerConstraints.maxWidth < 350) {
                                    fontSize = 16;
                                  } else if (innerConstraints.maxWidth < 400) {
                                    fontSize = 18;
                                  }

                                  return Text(
                                    'Denúncia realizada com sucesso!',
                                    style: GoogleFonts.lato(
                                      fontSize: fontSize,
                                      color: const Color(0xFF1B8C00),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Botão para retornar à tela inicial
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: containerMaxWidth),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Substitui a tela atual pela home
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF2A2F8C), // Azul SUDEMA
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Voltar à página inicial',
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
