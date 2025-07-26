/// NOTIFICATION_SERVICE
///
/// Responsável por: Gerenciamento de notificações push via Firebase Cloud Messaging
/// com controle de permissões e subscrição a tópicos.
/// Utilizado em: Configurações do app para habilitar/desabilitar notificações.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Classe NotificationService
///
/// Descrição: Serviço estático para gerenciamento completo de notificações
/// Firebase com persistência de preferências.
class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// INITIALIZE
  ///
  /// Descrição: Inicializa serviço de notificações solicitando permissões.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Fluxo: solicita permissão → obtém token FCM → log para debug
  static Future<void> initialize() async {
    // Solicita permissão do usuário para notificações
    await _messaging.requestPermission();
    // Obtém token FCM para identificação do dispositivo
    final token = await _messaging.getToken();
    print('🔑 FCM Token: $token');  // Log para debug/registro
  }

  /// SETNOTIFICATIONSENABLED
  ///
  /// Descrição: Habilita/desabilita notificações com persistência e subscrição a tópicos.
  /// Parâmetros:
  /// - enabled: true para habilitar, false para desabilitar
  /// Retorno: Future<void>
  ///
  /// Fluxo: salva preferência → subscribe/unsubscribe do tópico 'geral'
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    // Salva preferência do usuário localmente
    await prefs.setBool('notifications_enabled', enabled);
    
    if (enabled) {
      // Habilita: subscreve ao tópico geral para receber notificações
      await _messaging.subscribeToTopic('geral');
    } else {
      // Desabilita: remove subscrição do tópico geral
      await _messaging.unsubscribeFromTopic('geral');
    }
  }

  /// GETNOTIFICATIONSENABLED
  ///
  /// Descrição: Recupera estado atual das notificações salvo localmente.
  /// Parâmetros: nenhum
  /// Retorno: Future<bool> - true se habilitadas, false se desabilitadas
  ///
  /// Padrão: false (desabilitadas) se nunca foi configurado
  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_enabled') ?? false;  // Padrão: desabilitado
  }

  // Fim da classe NotificationService
  // 
  // Serviço de notificações com:
  // 
  // 🔔 FIREBASE MESSAGING:
  // - Inicialização com solicitação de permissões
  // - Obtenção de token FCM para identificação
  // - Subscrição/dessubscrição de tópicos
  // - Gerenciamento do tópico 'geral'
  // 
  // 💾 PERSISTÊNCIA:
  // - SharedPreferences para salvar preferências
  // - Estado binário: habilitado/desabilitado
  // - Padrão conservador: desabilitado
  // - Sincronização com Firebase
  // 
  // ⚙️ CONTROLE DE ESTADO:
  // - Métodos para habilitar/desabilitar
  // - Consulta de estado atual
  // - Ações automáticas no Firebase
  // - Interface simples para UI
}
