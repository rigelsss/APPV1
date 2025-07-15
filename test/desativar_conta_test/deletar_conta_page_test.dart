import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sudema_app/screens/perfil/menu/desativarConta/deletar_conta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MockClient extends Mock implements http.Client {}
class UriFake extends Fake implements Uri {}

void main() {
  late MockClient mockHttpClient;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockHttpClient = MockClient();

    registerFallbackValue(UriFake());
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Renderiza textos e botões corretamente', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DeletarContaPage()));

    expect(find.text('Deletar conta'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Confirmar'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
  });

  testWidgets('Alterna visibilidade da senha', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DeletarContaPage()));

    final eyeButton = find.byIcon(Icons.visibility_off);
    expect(eyeButton, findsOneWidget);

    await tester.tap(eyeButton);
    await tester.pump();

    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('Botão Cancelar volta para tela anterior', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const DeletarContaPage(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.byType(DeletarContaPage), findsNothing);
  });

  testWidgets('Token expirado redireciona para login', (tester) async {
    const expiredToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJleHAiOjE2MDAwMDAwMDB9.'
        'signature';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', expiredToken);

    await tester.pumpWidget(MaterialApp(
      routes: {
        '/login': (_) => const Scaffold(body: Text('Login Page')),
      },
      home: const DeletarContaPage(),
    ));

    await tester.enterText(find.byType(TextField), 'senhaqualquer');
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    expect(find.text('Login Page'), findsOneWidget);
  });



  testWidgets('Botão de voltar do appBar funciona', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const DeletarContaPage()),
      ),
    ));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(DeletarContaPage), findsNothing);
  });

  testWidgets('Senha é ocultada por padrão', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DeletarContaPage()));

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, isTrue);
  });

}
