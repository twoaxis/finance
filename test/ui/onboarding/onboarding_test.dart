import "package:financial_planner_mobile/ui/onboarding/onboarding.dart";
import "package:financial_planner_mobile/ui/onboarding/screens/login.dart";
import "package:financial_planner_mobile/ui/onboarding/screens/signup.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

Future<void> setup(WidgetTester tester) async {
  final testWidget = MaterialApp(
      home: Onboarding()
  );

  await tester.pumpWidget(testWidget);
}

void main() {
  testWidgets("Renders correct text", (WidgetTester tester) async {

    await setup(tester);

    expect(find.text("TwoAxis Finance"), findsOneWidget);
    expect(find.text("Manage your income, expense_sheets and assets with ease!"), findsOneWidget);
    expect(find.text("Login to your account"), findsOneWidget);
    expect(find.text("Create an account"), findsOneWidget);
    expect(find.text("Manage your income, expense_sheets and assets with ease!"), findsOneWidget);
    expect(find.text("By using our app, you're subject to our Privacy Policy."), findsOneWidget);

  });

  testWidgets("Goes to the login screen when pressed", (WidgetTester tester) async {

    await setup(tester);

    expect(find.byType(Onboarding), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);

    await tester.tap(find.text("Login to your account"));
    await tester.pumpAndSettle();

    expect(find.byType(Onboarding), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
  });
  testWidgets("Goes to the create account screen when pressed", (WidgetTester tester) async {
    await setup(tester);

    expect(find.byType(Onboarding), findsOneWidget);
    expect(find.byType(SignupPage), findsNothing);

    await tester.tap(find.text("Create an account"));
    await tester.pumpAndSettle();

    expect(find.byType(Onboarding), findsNothing);
    expect(find.byType(SignupPage), findsOneWidget);
  });
}
