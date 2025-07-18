import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sudema_app/screens/contatos/contatoss.dart';

// Mock dos métodos do controller
class MockController extends Mock {
  void abrirSiteSudema();
  void abrirSAAP();
}

void main() {
  late MockController mockController;

  setUp(() {
    mockController = MockController();
  });

  testWidgets('Renderiza os textos principais corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Contatoss()));

    expect(find.text('Contatos'), findsOneWidget);
    expect(find.text('Horário de funcionamento da SUDEMA:'), findsOneWidget);
    expect(find.text('Telefone para denúncias:'), findsOneWidget);
    expect(find.text('Telefone para contato SUDEMA:'), findsOneWidget);
    expect(find.textContaining('Superintendência'), findsOneWidget);
  });

  testWidgets('Renderiza os ícones e telefones corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Contatoss()));

    expect(find.byIcon(Icons.access_time), findsOneWidget);
    expect(find.byIcon(Icons.phone_in_talk_outlined), findsNWidgets(2));
    expect(find.text('+55 (83) 3690-1965'), findsOneWidget);
    expect(find.text('+55 (83) 3218-5606'), findsOneWidget);
  });


}
