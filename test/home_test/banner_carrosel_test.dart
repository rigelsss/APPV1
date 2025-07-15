import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/home/banner_carrossel.dart';

void main() {
  testWidgets('Renderiza as imagens e indicadores corretamente', (tester) async {
    bool onTapDenunciaCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BannerCarrossel(
            onTapDenuncia: () => onTapDenunciaCalled = true,
          ),
        ),
      ),
    );

    // Verifica se uma imagem é exibida (PageView mostra 1 imagem por vez)
    expect(find.byType(Image), findsOneWidget);

    // Verifica os 3 indicadores (círculos)
    final indicadores = find.byType(Container).evaluate().where((element) {
      final widget = element.widget as Container;
      return widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).shape == BoxShape.circle;
    });
    expect(indicadores.length, 3);
  });

  testWidgets('Chama onTapDenuncia ao clicar na imagem 0', (tester) async {
    bool onTapDenunciaCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BannerCarrossel(
            onTapDenuncia: () => onTapDenunciaCalled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    expect(onTapDenunciaCalled, isTrue);
  });
}
