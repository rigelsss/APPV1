import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:sudema_app/screens/notificacao/notificacao_widget.dart';

void main() {
  group('NotificacaoWidget', () {
    testWidgets('Exibe título, corpo e data formatada corretamente', (WidgetTester tester) async {
      final notificacao = {
        'titulo': 'Nova notícia',
        'corpo': 'Confira a nova atualização!',
        'dataCriacao': '09/07/2025 14:00:00',
        'isRead': true,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: NotificacaoWidget(
            notificacao: notificacao,
            index: 0,
            onMarcarComoLida: () {},
          ),
        ),
      );

      expect(find.text('Nova notícia'), findsOneWidget);
      expect(find.text('Confira a nova atualização!'), findsOneWidget);
      expect(find.text('09/07/2025 14:00'), findsOneWidget);
    });

    testWidgets('Card tem cor diferente se não lida', (WidgetTester tester) async {
      final notificacao = {
        'titulo': 'Alerta',
        'corpo': 'Você tem uma nova mensagem',
        'dataCriacao': '09/07/2025 12:00:00',
        'isRead': false,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: NotificacaoWidget(
            notificacao: notificacao,
            index: 1,
            onMarcarComoLida: () {},
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.grey[300]);
    });

    testWidgets('Chama onMarcarComoLida quando não lida e clicada', (WidgetTester tester) async {
      bool foiMarcadaComoLida = false;

      final notificacao = {
        'titulo': 'Alerta',
        'corpo': 'Você tem uma nova mensagem',
        'dataCriacao': '09/07/2025 12:00:00',
        'isRead': false,
        'tipo': '',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: NotificacaoWidget(
            notificacao: notificacao,
            index: 1,
            onMarcarComoLida: () {
              foiMarcadaComoLida = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump(); // Aguarda a ação do onTap

      expect(foiMarcadaComoLida, isTrue);
    });

    testWidgets('Não chama onMarcarComoLida se já foi lida', (WidgetTester tester) async {
      bool foiChamado = false;

      final notificacao = {
        'titulo': 'Notificação Lida',
        'corpo': 'Conteúdo',
        'dataCriacao': '09/07/2025 10:00:00',
        'isRead': true,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: NotificacaoWidget(
            notificacao: notificacao,
            index: 0,
            onMarcarComoLida: () {
              foiChamado = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(foiChamado, isFalse);
    });

    testWidgets('Exibe "-" se data for inválida', (WidgetTester tester) async {
      final notificacao = {
        'titulo': 'Sem data',
        'corpo': 'Sem data válida',
        'dataCriacao': 'data_invalida',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: NotificacaoWidget(
            notificacao: notificacao,
            index: 0,
            onMarcarComoLida: () {},
          ),
        ),
      );

      expect(find.text('-'), findsWidgets);
    });
  });
}
