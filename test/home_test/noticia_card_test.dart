import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/models/noticia.dart';
import 'package:sudema_app/screens/noticias/pagina_noticiaCompleta/noticiaCompleta_screen.dart';

import '../../lib/screens/home/noticia_card.dart';

void main() {
  // Cria uma Noticia fake para teste
  final noticiaFake = Noticia(
    id: '1',
    titulo: 'Título de teste',
    resumo: 'Resumo da notícia para teste.',
    imagemUrl: 'https://via.placeholder.com/150',
    dataHoraPublicacao: DateTime(2025, 7, 11, 15, 30),
  );

  testWidgets('NoticiaCard renderiza corretamente o conteúdo', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoticiaCard(noticia: noticiaFake),
        ),
      ),
    );

    // Verifica se o título aparece
    expect(find.text('Título de teste'), findsOneWidget);

    // Verifica se o resumo aparece
    expect(find.text('Resumo da notícia para teste.'), findsOneWidget);

    // Verifica se a data e hora estão formatadas e visíveis
    expect(find.text('11/07/2025   15h30'), findsOneWidget);

    // Verifica se a imagem está presente (CachedNetworkImage usa widget Image internamente)
    expect(find.byType(Image), findsWidgets); // pode haver mais de uma imagem por causa do placeholder
  });
}
