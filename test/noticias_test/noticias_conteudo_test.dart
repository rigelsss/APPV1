import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';  // importe o package
import 'package:flutter/material.dart';
import 'package:sudema_app/screens/noticias/pagina_noticiaCompleta/noticia_conteudo.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  final noticiaFake = {
    'titulo': '<h1>Título HTML</h1>',
    'resumo': '<p>Resumo com <b>negrito</b></p>',
    'data_publicacao_formatada': '16/07/2025',
    'imagem_url': 'https://example.com/imagem.jpg',
    'conteudo': '<p>Conteúdo com <i>HTML</i></p>',
    'categorias': ['Tag1', 'Tag2']
  };

  final noticiaCompleta = {
    'titulo': '<h1>Notícia <b>Importante</b></h1>',
    'resumo': '<p>Resumo <i>com</i> HTML</p>',
    'data_publicacao_formatada': '2025-07-16',
    'imagem_url': 'https://example.com/imagem.jpg',
    'conteudo': '<p>Conteúdo <strong>HTML</strong> da notícia</p>',
    'categorias': ['Política', 'Economia'],
  };

  // Dados com imagem null e categorias vazias
  final noticiaSemImagemCategorias = {
    'titulo': 'Título sem imagem',
    'resumo': 'Resumo simples',
    'data_publicacao_formatada': '2025-07-17',
    'imagem_url': null,
    'conteudo': 'Conteúdo sem tags',
    'categorias': [],
  };

  testWidgets('Mostra título, resumo, data e imagem corretamente', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoticiaConteudo(noticia: noticiaFake),
          ),
        ),
      );

      expect(find.text('Título HTML'), findsOneWidget);
      expect(find.text('Resumo com negrito'), findsOneWidget);
      expect(find.text('Publicado: 16/07/2025'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Tag1'), findsOneWidget);
      expect(find.text('Tag2'), findsOneWidget);
      expect(find.byType(Html), findsOneWidget);
    });
  });

  testWidgets('Exibe texto longo sem quebrar layout', (tester) async {
    final noticiaLonga = {
      'titulo': 'Título muito longo ' * 10,
      'resumo': 'Resumo muito longo ' * 20,
      'data_publicacao_formatada': '2025-07-18',
      'imagem_url': null,
      'conteudo': 'Conteúdo longo',
      'categorias': ['Categoria1'],
    };

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: NoticiaConteudo(noticia: noticiaLonga)),
    ));

    expect(find.textContaining('Título muito longo'), findsOneWidget);
    expect(find.textContaining('Resumo muito longo'), findsOneWidget);
  });

  testWidgets('Remove tags HTML corretamente do título, resumo e conteúdo', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: NoticiaConteudo(noticia: noticiaCompleta),
    ));

    expect(find.text('Notícia Importante'), findsOneWidget);
    expect(find.text('Resumo com HTML'), findsOneWidget);
  });

  testWidgets('Exibe texto longo sem quebrar layout', (tester) async {
    final noticiaLonga = {
      'titulo': 'Título muito longo ' * 10,
      'resumo': 'Resumo muito longo ' * 20,
      'data_publicacao_formatada': '2025-07-18',
      'imagem_url': null,
      'conteudo': 'Conteúdo longo',
      'categorias': ['Categoria1'],
    };

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: NoticiaConteudo(noticia: noticiaLonga)),
    ));

    expect(find.textContaining('Título muito longo'), findsOneWidget);
    expect(find.textContaining('Resumo muito longo'), findsOneWidget);
  });

  testWidgets('Tem espaçamento entre os elementos com SizedBox', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: NoticiaConteudo(noticia: noticiaCompleta),
    ));

    final sizedBoxFinder = find.byType(SizedBox);
    expect(sizedBoxFinder, findsWidgets);
  });

  testWidgets('Usa fonte Google Lato para textos', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: NoticiaConteudo(noticia: noticiaCompleta),
    ));

    final tituloText = tester.widget<Text>(find.text('Notícia Importante'));
    expect(tituloText.style?.fontFamily?.toLowerCase(), contains('lato'));
  });

  testWidgets('Não exibe categorias quando lista está vazia', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: NoticiaConteudo(noticia: noticiaSemImagemCategorias),
    ));


    expect(find.byType(Chip), findsNothing);

    expect(find.text('Política'), findsNothing);
    expect(find.text('Economia'), findsNothing);
  });

}
