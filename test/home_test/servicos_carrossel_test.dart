import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/home/servicos_carrossel.dart'; // Ajuste conforme seu path

import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Mock seguro sem usar mockito
class FakeUrlLauncher extends Fake with MockPlatformInterfaceMixin implements UrlLauncherPlatform {
  Uri? lastLaunched;
  String? lastLaunchedRaw;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    lastLaunchedRaw = url;
    return true;
  }
}

void main() {
  late List<String> selecionados;
  late FakeUrlLauncher fakeUrlLauncher;

  setUp(() {
    selecionados = [];
    fakeUrlLauncher = FakeUrlLauncher();
    UrlLauncherPlatform.instance = fakeUrlLauncher;
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: ServicosCarrossel(
          onSelecionar: (label) => selecionados.add(label),
        ),
      ),
    );
  }

  group('ServicosCarrossel', () {
    testWidgets('Renderiza todos os serviços com label', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Balneabilidade'), findsOneWidget);
      expect(find.text('Denúncias'), findsOneWidget);
      expect(find.text('Transparência'), findsOneWidget);
      expect(find.text('Licenciamento'), findsOneWidget);
      expect(find.text('CTE'), findsOneWidget);
    });

    testWidgets('Clica em serviço sem URL chama onSelecionar', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Balneabilidade'));
      await tester.pumpAndSettle();

      expect(selecionados.contains('balneabilidade'), isTrue);
    });

    testWidgets('Clica em serviço com URL chama launchUrl', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Transparência'));
      await tester.pumpAndSettle();

      expect(fakeUrlLauncher.lastLaunchedRaw, 'https://sigma.pb.gov.br/transparencia/');
    });

    testWidgets('Indicador é alterado ao rolar horizontalmente', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final listView = find.byType(ListView);
      await tester.drag(listView, const Offset(-300, 0));
      await tester.pumpAndSettle();

      final indicadorAtivo = find.byWidgetPredicate((widget) {
        return widget is AnimatedContainer &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == const Color(0xFF2A2F8C);
      });

      expect(indicadorAtivo, findsOneWidget);
    });

    testWidgets('Lista é scrollável na horizontal', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);

      await tester.drag(listView, const Offset(-250, 0));
      await tester.pump();
    });
  });
}
