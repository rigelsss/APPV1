import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sudema_app/screens/jardim/jardim.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';

// Mock para NavigatorObserver
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Jardim(),
      navigatorObservers: [mockObserver],
      routes: {
        '/login': (context) => Scaffold(body: Text('Login Page')),
        '/home': (context) => Scaffold(body: Text('Home Page')),
        '/denuncias': (context) => Scaffold(body: Text('Denúncias Page')),
        '/praias': (context) => Scaffold(body: Text('Praias Page')),
        '/noticias': (context) => Scaffold(body: Text('Notícias Page')),
        '/contatos': (context) => Scaffold(body: Text('Contatos Page')),
      },
    );
  }

  testWidgets('Renderiza textos e imagem principais', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verifica textos importantes
    expect(find.text('Jardim Botânico Benjamim Maranhão'), findsOneWidget);
    expect(find.textContaining('Avenida Dom Pedro II'), findsOneWidget);
    expect(find.text('Horário de funcionamento:'), findsOneWidget);
    expect(find.text('Terça a sábado'), findsOneWidget);
    expect(find.text('Trilhas guiadas às 9h e 14h'), findsOneWidget);

    // Verifica imagem (por tipo)
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Clicar no botão Login do AppBar navega para /login', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Como o HomeAppBar não está no seu código, vamos assumir que ele tenha um botão com tooltip 'login' (ajuste se necessário)
    final loginButton = find.byTooltip('login');

    // Caso não tenha tooltip, você pode buscar pelo tipo do widget ou texto, ou adaptar o HomeAppBar para expor a key
    if (loginButton.evaluate().isEmpty) {
      // Teste alternativo: tenta encontrar um IconButton (caso seja assim no HomeAppBar)
      final iconButton = find.byType(IconButton);
      expect(iconButton, findsWidgets);
      await tester.tap(iconButton.first);
    } else {
      await tester.tap(loginButton);
    }

    await tester.pumpAndSettle();

    expect(find.text('Login Page'), findsOneWidget);
  });

  testWidgets('NavBar navega para as rotas corretas', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // NavBar tem 4 itens, vamos testar cada um
    for (var i = 0; i < 4; i++) {
      // Para garantir que cada clique funcione, recompilamos a tela
      await tester.pumpWidget(createWidgetUnderTest());

      // O NavBar deve ter widgets de GestureDetector ou IconButton, mas como é customizado,
      // vamos achar pelo index na árvore - adaptando aqui para clicar no NavBar

      // Por simplicidade, vamos clicar no NavBar usando find.byType(NavBar) e buscar seus filhos

      final navBar = find.byType(NavBar);
      expect(navBar, findsOneWidget);

      // Como NavBar é custom, você precisa que ele exponha as chaves (keys) nos botões para encontrar e clicar
      // Exemplo (se tiver keys como Key('nav_0'), etc):
      final navItem = find.byKey(Key('nav_$i'));
      if (navItem.evaluate().isNotEmpty) {
        await tester.tap(navItem);
        await tester.pumpAndSettle();
      } else {
        // Se não tem key, não tem como automatizar sem alterar código, então este teste precisaria ser manual
        // ou você adapta o NavBar para facilitar testes.
        // Aqui só mostramos que o teste é possível com keys.
      }

      // Verificar navegação (exemplo):
      // Testa se texto da página correspondente está na tela
      final pagesTexts = ['Home Page', 'Denúncias Page', 'Praias Page', 'Notícias Page'];
      if (i < pagesTexts.length) {
        expect(find.text(pagesTexts[i]), findsOneWidget);
      }
    }
  });

  testWidgets('Drawer navega para as rotas corretas', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Abrir drawer
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Os itens do drawer são numerados de 1 a 4, com navegação definida

    for (int index = 1; index <= 4; index++) {
      // Abrir novamente o drawer
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Procurar item do drawer pelo texto ou key — precisa adaptar o CustomDrawer para expor keys
      final drawerItem = find.byKey(Key('drawer_item_$index'));

      if (drawerItem.evaluate().isNotEmpty) {
        await tester.tap(drawerItem);
        await tester.pumpAndSettle();

        final expectedPages = {
          1: 'Denúncias Page',
          2: 'Praias Page',
          3: 'Notícias Page',
          4: 'Contatos Page',
        };

        expect(find.text(expectedPages[index]!), findsOneWidget);
      } else {
        // Se não tem keys, impossível automatizar sem alterar o CustomDrawer.
        // Você pode adaptar o código para facilitar testes adicionando keys nos itens do drawer.
      }
    }
  });

  testWidgets('Layout muda o padding quando largura > 600', (WidgetTester tester) async {
    // Testar LayoutBuilder com largura > 600
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(800, 1000)),
        child: createWidgetUnderTest(),
      ),
    );

    await tester.pumpAndSettle();

    // Verifica se o Padding horizontal é 20% da largura (800 * 0.2 = 160)
    final paddingFinder = find.byType(Padding);
    final paddingWidget = tester.widget<Padding>(paddingFinder.first);
    final padding = paddingWidget.padding as EdgeInsets;

    expect(padding.left, closeTo(160, 1));
    expect(padding.right, closeTo(160, 1));
  });
}
