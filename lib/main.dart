import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:sudema_app/screens/EditEmail.dart';
import 'package:sudema_app/screens/EditSenha.dart';
import 'package:sudema_app/screens/PageDenuncia.dart';
import 'package:sudema_app/screens/PerfilUser.dart';
import 'package:sudema_app/screens/contatos.dart';
import 'package:sudema_app/screens/home_screen.dart';
import 'package:sudema_app/screens/login.dart';
import 'package:sudema_app/screens/splash_screen.dart';
import 'package:sudema_app/screens/editarperfil.dart';

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
        '/denuncias': (context) => const DenunciaPage(),
        '/editar-perfil': (context) => const editarperfil(),
        '/EditarEmail': (context) => const EditarEmail(),
        '/EditarSenha': (context) => const EditarSenha(),
        '/perfiluser': (context) => const Perfiluser(),
        '/contatos' : (context) => const Contatos(),
      },
    );
  }
}
