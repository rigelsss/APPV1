import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_info_label.dart';

void main() {
  testWidgets('LabeledInfoItem exibe corretamente label e valor', (WidgetTester tester) async {
    const label = 'Nome';
    const value = 'User test';

    // Renderiza o widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LabeledInfoItem(
            label: label,
            value: value,
          ),
        ),
      ),
    );

    expect(find.text('$label:'), findsOneWidget);
    expect(find.text(value), findsOneWidget);
  });
}
