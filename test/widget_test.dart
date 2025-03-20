import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Widget displays correct text', (WidgetTester tester) async {
    // Define the widget
    final testWidget = MaterialApp(
      home: Scaffold(body: Text('Hello, Flutter!')),
    );

    // Build the widget
    await tester.pumpWidget(testWidget);

    // Verify the text appears on screen
    expect(find.text('Hello, Flutter!'), findsOneWidget);
  });
}
