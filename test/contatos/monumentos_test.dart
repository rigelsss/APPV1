import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/monumentos/monumentos.dart';
import 'package:sudema_app/screens/widgets/appbar.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/widgets/drawer.dart';

void main() {
  testWidgets('Renderiza título, imagem e textos principais', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Monumentos()));

    expect(find.text('Monumento Natural Vale dos Dinossauros (MONA)'), findsOneWidget);

    expect(
      find.byWidgetPredicate(
            (widget) =>
        widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/images/imagevale.png',
      ),
      findsOneWidget,
    );

    expect(find.textContaining('O Vale dos Dinossauros'), findsOneWidget);
    expect(find.text('Horário de funcionamento:'), findsOneWidget);
    expect(find.text('Atividades:'), findsOneWidget);
  });

  testWidgets('Renderiza AppBar, Drawer e BottomNavigationBar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Monumentos()));

    // Verifica AppBar e NavBar
    expect(find.byType(HomeAppBar), findsOneWidget);
    expect(find.byType(NavBar), findsOneWidget);

    // Abre o Drawer manualmente
    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();

    // Verifica se o Drawer foi aberto
    expect(find.byType(CustomDrawer), findsOneWidget);
  });

  testWidgets('Navega para /login ao clicar no botão de login do AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: {
        '/login': (_) => const Scaffold(body: Text('Página de Login')),
      },
      home: const Monumentos(),
    ));

    await tester.pumpAndSettle();

    final loginButton = find.byKey(const Key('login_button'));
    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Página de Login'), findsOneWidget);
  });

  testWidgets('Verifica box de horário de funcionamento', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Monumentos()));

    expect(find.text('Terça a domingo'), findsOneWidget);
    expect(find.text('08:00 às 12:00  |  14:00 às 17:00'), findsOneWidget);
  });

  testWidgets('Verifica box de atividades', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Monumentos()));

    expect(find.text('Museu e trilhas de pegadas'), findsOneWidget);
    expect(find.text('Visitas guiadas às 9h, 10h, 11h, 15h e 16h'), findsOneWidget);
  });

  testWidgets('Dispara onTap ao clicar em item do NavBar', (WidgetTester tester) async {
    int? tappedIndex;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        bottomNavigationBar: NavBar(
          currentIndex: -1,
          onTap: (index) {
            tappedIndex = index;
          },
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Toca no primeiro item (ícone de Início)
    final homeNavItem = find.byKey(const Key('navbar_item_0'));
    expect(homeNavItem, findsOneWidget);

    await tester.tap(homeNavItem);
    await tester.pump();

    expect(tappedIndex, equals(0));
  });

}
