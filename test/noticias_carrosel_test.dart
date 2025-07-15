import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/models/noticia.dart';
import 'package:sudema_app/screens/home/noticia_card.dart';
import 'package:sudema_app/screens/home/noticias_carrossel.dart'; // ajuste conforme seu caminho

void main() {
  // Mock simples de notícias
  final noticiasFake = List.generate(
    3,
        (index) => Noticia(
      id: '$index',
      titulo: 'Título $index',
      resumo: 'Resumo $index',
      imagemUrl: 'https://via.placeholder.com/150',
      dataHoraPublicacao: DateTime(2025, 7, 11, 15, 30),
    ),
  );

  testWidgets('Renderiza o número correto de NoticiaCard', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoticiasCarrossel(noticias: noticiasFake),
        ),
      ),
    );

    // Deve renderizar pelo menos um NoticiaCard visível (PageView constrói só o atual)
    expect(find.byType(NoticiaCard), findsWidgets);
  });

  testWidgets('Exibe indicadores corretos e página inicial é 0', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoticiasCarrossel(noticias: noticiasFake),
        ),
      ),
    );

    // Verifica número de indicadores (bolinhas)
    expect(find.byType(AnimatedContainer), findsNWidgets(noticiasFake.length));

    // O indicador da primeira página (index 0) deve ter cor ativa (0xFF2A2F8C)
    final indicadorAtivo = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer)).first;
    final decoration = indicadorAtivo.decoration as BoxDecoration;
    expect(decoration.color, const Color(0xFF2A2F8C));
  });
  testWidgets('Comportamento com lista vazia: não renderiza cards nem indicadores', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoticiasCarrossel(noticias: []),
        ),
      ),
    );

    // Não deve encontrar nenhum NoticiaCard
    expect(find.byType(NoticiaCard), findsNothing);

    // Não deve encontrar indicadores (bolinhas)
    expect(find.byType(AnimatedContainer), findsNothing);
  });
}
