import "package:financial_planner_mobile/ui/onboarding/onboarding.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("Renders correct text", (WidgetTester tester) async {

    final testWidget = MaterialApp(
      home: Onboarding()
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("TwoAxis Finance"), findsOneWidget);
    expect(find.text("Manage your income, expense_sheets and assets with ease!"), findsOneWidget);
    expect(find.text("By using our app, you're subject to our Privacy Policy."), findsOneWidget);

  });


}
