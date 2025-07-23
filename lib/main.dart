import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:sudema_app/screens/perfil/menu/alteraremail/alterar_email.dart';
import 'package:sudema_app/screens/contatos/contatoss.dart';
import 'package:sudema_app/screens/perfil/menu/desativarConta/deletar_conta.dart';
import 'package:sudema_app/screens/perfil/menu/alterarsenha/alterar_senha.dart';
import 'package:sudema_app/screens/notificacao/notificacoes.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_page.dart';
import 'package:sudema_app/screens/home/home_screen.dart';
import 'package:sudema_app/screens/login/login.dart';
import 'package:sudema_app/screens/diversos/splash_screen.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/editar_perfil.dart';
import 'package:sudema_app/screens/diversos/reativar_conta.dart';
import 'package:sudema_app/services/notification_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/cadastro/confirmar_cadastro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sudema_app/screens/denuncia/denunciawraprellerscreen.dart';
import 'package:sudema_app/utils/no_glow_scroll_configuracao.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 [Background] Mensagem recebida: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/env/.env");

  await Firebase.initializeApp();

  await NotificationHandler.createNotificationChannel();
  await NotificationHandler.initializeFlutterNotifications();
  NotificationHandler.listenToForegroundMessages();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        title: 'SUDEMA',
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF2A2F8C),           // cursor
            selectionColor: Color(0x332A2F8C),        // fundo da seleção (com opacidade)
            selectionHandleColor: Color(0xFF2A2F8C),  // "gotinha"
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(initialIndex: 0),
          '/login': (context) => const LoginPage(),
          '/balneabilidade': (context) => const HomeScreen(initialIndex: 2),
          '/noticias': (context) => const HomeScreen(initialIndex: 3),
          '/denuncias': (context) => const HomeScreen(initialIndex: 1),
          '/editar-perfil': (context) => const EditarPerfil(nomeAtual: '', telefoneAtual: '', cpfAtual: ''),
          '/EditarEmail': (context) => const EditarEmail(),
          '/EditarSenha': (context) => const EditarSenha(),
          '/perfil': (context) => const Perfiluser(),
          '/deletar-conta': (context) => const DeletarContaPage(),
          '/reativar-conta': (context) => const ReativarContaPage(email: '', senha: ''),
          '/notificacoes': (context) => const NotificacoesPage(token: ''),
          '/codigoRegistro': (context) => const CodigoRegistro(email: ''),
          '/denuncia': (context) => DenunciaWrapperScreen(),
          '/praias': (context) => const HomeScreen(initialIndex: 2),
          '/contatoss': (context) => Contatoss(),
        },
      ),
    );
  }
}