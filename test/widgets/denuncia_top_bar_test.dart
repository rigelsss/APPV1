import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/widgets/denuncia_top_bar.dart';

void main() {
  final opcoes = ['Opção 1', 'Opção 2', 'Opção 3'];

  group('DenunciaTopBar Widget', () {
    testWidgets('Renderiza todas as opções', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DenunciaTopBar(
              opcoes: opcoes,
              selectedIndex: 0,
              podeIrParaAba: (_) => true,
              onSelecionar: (_) {},
            ),
          ),
        ),
      );

      for (final opcao in opcoes) {
        expect(find.text(opcao), findsOneWidget);
      }
    });

    testWidgets('Texto tem cor correta conforme seleção e habilitação', (WidgetTester tester) async {
      bool podeIrParaAba(int index) => index != 1; // index 1 desabilitado

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DenunciaTopBar(
              opcoes: opcoes,
              selectedIndex: 0,
              podeIrParaAba: podeIrParaAba,
              onSelecionar: (_) {},
            ),
          ),
        ),
      );

      final selecionado = tester.widget<Text>(find.text('Opção 1'));
      expect(selecionado.style?.color, Colors.blue[900]);

      final habilitado = tester.widget<Text>(find.text('Opção 3'));
      expect(habilitado.style?.color, Colors.grey[700]);

      final desabilitado = tester.widget<Text>(find.text('Opção 2'));
      expect(desabilitado.style?.color, Colors.grey[400]);
    });

    testWidgets('Exibe underline só no item selecionado', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DenunciaTopBar(
              opcoes: opcoes,
              selectedIndex: 1,
              podeIrParaAba: (_) => true,
              onSelecionar: (_) {},
            ),
          ),
        ),
      );

      final underlineContainers = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.color == Colors.blue[900] && widget.constraints?.minHeight == 3;
        }
        return false;
      });

      expect(underlineContainers, findsOneWidget);
    });

    testWidgets('Chama onSelecionar ao clicar numa opção', (WidgetTester tester) async {
      int? selecionado;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DenunciaTopBar(
              opcoes: opcoes,
              selectedIndex: 0,
              podeIrParaAba: (_) => true,
              onSelecionar: (index) {
                selecionado = index;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Opção 3'));
      await tester.pump();

      expect(selecionado, 2);
    });
  });
}
