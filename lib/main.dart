import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sudema_app/screens/alterar_email.dart';
import 'package:sudema_app/screens/deletar_conta.dart';
import 'package:sudema_app/screens/EditSenha.dart';
import 'package:sudema_app/screens/PageDenuncia.dart';
import 'package:sudema_app/screens/perfil_page.dart';
import 'package:sudema_app/screens/contatos.dart';
import 'package:sudema_app/screens/home_screen.dart';
import 'package:sudema_app/screens/login.dart';
import 'package:sudema_app/screens/praias.dart';
import 'package:sudema_app/screens/splash_screen.dart';
import 'package:sudema_app/screens/editar_perfil.dart';
import 'package:sudema_app/screens/noticias.dart';

import 'package:sudema_app/services/notification_handler.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SUDEMA',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginPage(),
        '/balneablilidade': (context) => const PraiasPage(),
        '/noticias': (context) => const NoticiasPage(),
        '/denuncias': (context) => const DenunciaPage(),
        '/editar-perfil': (context) => const EditarPerfil(),
        '/EditarEmail': (context) => const EditarEmail(),
        '/EditarSenha': (context) => const EditarSenha(),
        '/perfil': (context) => const Perfiluser(),
        '/contatos' : (context) => const Contatos(),
        '/deletar-conta': (context) => DeletarContaPage(userId: ''),
      },
    );
  }
}
