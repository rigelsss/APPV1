import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/widgets/categoria_selector.dart';

void main() {
  group('CategoriaSelector', () {
    testWidgets('Exibe mensagem quando categorias está vazia', (tester) async {
      await tester.pumpWidget(
         MaterialApp(
          home: Scaffold(
            body: CategoriaSelector(
              categorias: [],
              iconesPorCategoria: {},
              categoriaSelecionada: null,
              subcategoriaSelecionada: null,
              categoriasExpandidas: {},
              onSubcategoriaSelecionada: (_, __, ___) {},
              onCategoriaSelecionada: (_) {},
              onToggleExpand: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Nenhuma categoria disponível.'), findsOneWidget);
    });

    testWidgets('Renderiza categoria e subcategorias ao expandir', (tester) async {
      final categorias = [
        {
          'id': 1,
          'nome': 'Categoria 1',
          'tiposDenuncia': [
            {'id': 10, 'nome': 'Subcategoria 1'},
            {'id': 11, 'nome': 'Subcategoria 2'},
          ],
        },
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoriaSelector(
              categorias: categorias,
              iconesPorCategoria: {1: 'assets/images/image-break.png'},
              categoriaSelecionada: 'Categoria 1',
              subcategoriaSelecionada: 'Subcategoria 2',
              categoriasExpandidas: {0},
              onSubcategoriaSelecionada: (_, __, ___) {},
              onCategoriaSelecionada: (_) {},
              onToggleExpand: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Categoria 1'), findsOneWidget);
      expect(find.text('Subcategoria 1'), findsOneWidget);
      expect(find.text('Subcategoria 2'), findsOneWidget);
    });

    testWidgets('Executa onCategoriaSelecionada e onToggleExpand ao tocar na categoria', (tester) async {
      bool categoriaTocada = false;
      bool expandido = false;

      final categorias = [
        {
          'id': 1,
          'nome': 'Categoria X',
          'tiposDenuncia': [],
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoriaSelector(
              categorias: categorias,
              iconesPorCategoria: {},
              categoriaSelecionada: null,
              subcategoriaSelecionada: null,
              categoriasExpandidas: {},
              onSubcategoriaSelecionada: (_, __, ___) {},
              onCategoriaSelecionada: (_) => categoriaTocada = true,
              onToggleExpand: (_) => expandido = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Categoria X'));
      await tester.pumpAndSettle();

      expect(categoriaTocada, isTrue);
      expect(expandido, isTrue);
    });

    testWidgets('Executa onSubcategoriaSelecionada ao tocar em subcategoria', (tester) async {
      String? subSelecionada;
      int? subIdSelecionado;

      final categorias = [
        {
          'id': 1,
          'nome': 'Cat',
          'tiposDenuncia': [
            {'id': 99, 'nome': 'SubCat'},
          ],
        },
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoriaSelector(
              categorias: categorias,
              iconesPorCategoria: {},
              categoriaSelecionada: 'Cat',
              subcategoriaSelecionada: null,
              categoriasExpandidas: {0},
              onSubcategoriaSelecionada: (nome, id, _) {
                subSelecionada = nome;
                subIdSelecionado = id;
              },
              onCategoriaSelecionada: (_) {},
              onToggleExpand: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('SubCat'));
      await tester.pumpAndSettle();

      expect(subSelecionada, 'SubCat');
      expect(subIdSelecionado, 99);
    });
  });
}
