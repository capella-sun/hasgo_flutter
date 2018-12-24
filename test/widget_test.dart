import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hasgo_flutter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that we have Create and Join Buttons
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Join'), findsOneWidget);
  });
}
