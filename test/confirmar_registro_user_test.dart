import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sudema_app/screens/registerUser/confirmarRegistro.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  testWidgets('Renderiza textos principais da tela CodigoRegistro',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CodigoRegistro(email: 'teste@email.com'),
          ),
        );

        // Verifica título da AppBar
        expect(find.text('Verificar Conta'), findsOneWidget);

        // Verifica o texto de instrução
        expect(
          find.textContaining('Um código de verificação foi enviado para o seu e-mail'),
          findsOneWidget,
        );

        // Verifica botão 'Verificar'
        expect(find.text('Verificar'), findsOneWidget);

        // Verifica o texto entre as divisórias
        expect(find.text('Não recebeu o código?'), findsOneWidget);

        // Verifica botão 'enviar novamente'
        expect(find.text('enviar novamente'), findsOneWidget);
      });


  testWidgets(('erro se o codigo tiver menos de 6 digitos'), (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CodigoRegistro(email: 'teste@gmail.com'),
      ),
    );

    await tester.enterText(find.byType(TextField), '123');

    // Toca no botão "Verificar"
    await tester.tap(find.text('Verificar'));
    await tester.pump(); // Avança um frame para mostrar o SnackBar

    // Verifica se o erro apareceu no SnackBar
    expect(find.text('Por favor, insira o código de 6 dígitos.'), findsOneWidget);
    await tester.enterText(find.byType(PinCodeTextField), '123');

    // Toca no botão "Verificar"
    await tester.tap(find.text('Verificar'));
    await tester.pump(); // Avança um frame para mostrar o SnackBar

    // Verifica se o erro apareceu no SnackBar
    expect(find.text('Por favor, insira o código de 6 dígitos.'), findsOneWidget);

  });

}
