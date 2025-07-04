import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/screens/perfil_page.dart';
import 'package:sudema_app/services/AuthMe.dart';
import '../contatos/contatoss.dart';
import '../../utils/logout_helper.dart';

class CustomDrawer extends StatefulWidget {
  final Function(int) onItemSelected;
  const CustomDrawer({super.key, required this.onItemSelected});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  String username = 'Acessar';
  bool isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _carregarTokenEUsuario();
  }

  Future<void> _carregarTokenEUsuario() async {
    final token = await AuthController.getToken();
    setState(() => _token = token);

    if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      try {
        final data = await AuthController.obterInformacoesUsuario(token);
        if (data != null) {
          final nomeCompleto = data['name'] ?? 'Acessar';
          final primeiroNome = nomeCompleto.split(' ').first;
          setState(() {
            username = primeiroNome;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } catch (e) {
        print('Erro ao carregar nome do usuário: $e');
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  bool get isLoggedIn {
    if (_token == null || _token!.isEmpty) return false;
    try {
      return !JwtDecoder.isExpired(_token!);
    } catch (e) {
      return false;
    }
  }

  Widget _customDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 15, right: 30),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFB8B8B8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Center(
              child: Image.asset(
                'assets/images/logosimples.png',
                width: 130,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icon/bullhorn.svg', // caminho do seu arquivo SVG
                    width: 22,
                    height: 22,
                    color: Color(0xFF3B3B3B), // se quiser aplicar cor
                  ),
                  title:  Text('Denúncias', style: GoogleFonts.lato(fontSize: 18, color: Colors.black),),
                  onTap: () => widget.onItemSelected(1),
                ),
                _customDivider(),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icon/umbrella-beach.svg',
                    width: 22,
                    height: 22,
                    color: Color(0xFF3B3B3B),
                  ),
                  title: Text('Balneabilidade', style: GoogleFonts.lato(fontSize: 18, color: Colors.black),),
                  onTap: () => widget.onItemSelected(2),
                ),
                _customDivider(),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icon/newspaper.svg',
                    width: 22,
                    height: 22,
                    color: Color(0xFF3B3B3B),
                  ),
                  title: Text('Notícias', style: GoogleFonts.lato(fontSize: 18, color: Colors.black),),
                  onTap: () => widget.onItemSelected(3),
                ),
                _customDivider(),
                ListTile(
                  leading:SvgPicture.asset(
                  'assets/icon/phone-call.svg',
                  width: 22,
                  height: 22,
                  color: Color(0xFF3B3B3B),
                ),
                  title: Text('Contato', style: GoogleFonts.lato(fontSize: 18, color: Colors.black),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Contatoss()),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 36),
            child: Column(
              children: [
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/user.svg',
                      width: 26,
                      height: 26,
                      color: Color(0xFF3B3B3B),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (isLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Perfiluser(token: _token)),
                            );
                          } else {
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        child: Text(
                          isLoading ? 'Carregando...' : username,
                          style: GoogleFonts.lato(fontSize: 18),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isLoggedIn) {
                          confirmarLogout(context, onLogout: () async {
                            await AuthController.logout();
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                              setState(() {
                                _token = null;
                                username = 'Acessar';
                              });
                            }
                          });
                        } else {
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                      child: SvgPicture.asset(
                        isLoggedIn ? 'assets/icon/log-out.svg' : 'assets/icon/log-out.svg',
                        width: 22,
                        height: 22,
                        color: Color(0xFF3B3B3B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
