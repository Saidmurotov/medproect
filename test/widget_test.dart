import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medproect/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton renders text and handles taps', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(text: 'Saqlash', onPressed: () => tapped = true),
        ),
      ),
    );

    expect(find.text('Saqlash'), findsOneWidget);

    await tester.tap(find.text('Saqlash'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
