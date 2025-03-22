import 'package:financial_planner_mobile/abstract/auth_service.dart';
import 'package:financial_planner_mobile/ui/onboarding/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/auth.mocks.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setupWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: Text("Go to Login"),
            ),
          ),
        ),
      ),
    );
  }

  setUp(() {
    mockAuthService = MockAuthService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    GetIt.I.reset();
  });


  testWidgets("Should pop on success", (WidgetTester tester) async {

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockAuthService.signInWithEmailAndPassword(any, any)).thenAnswer((_) async => mockUserCredential);

    GetIt.I.registerSingleton<AuthService>(mockAuthService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Login"));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(find.byKey(Key("email")), "test@twoaxis.org");
    await tester.enterText(find.byKey(Key("password")), "password123");

    await tester.tap(find.byKey(Key("login")));
    await tester.pumpAndSettle();

    verify(mockAuthService.signInWithEmailAndPassword("test@twoaxis.org", "password123")).called(1);

    expect(find.byType(LoginPage), findsNothing);

  });

  testWidgets("Should show an AlertDialog on invalid E-mail", (WidgetTester tester) async {

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('abc123');
    when(mockAuthService.signInWithEmailAndPassword(any, any)).thenThrow(FirebaseAuthException(code: "invalid-email"));

    GetIt.I.registerSingleton<AuthService>(mockAuthService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Login"));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(find.byKey(Key("email")), "test@twoaxis.org");
    await tester.enterText(find.byKey(Key("password")), "password123");

    await tester.tap(find.byKey(Key("login")));
    await tester.pumpAndSettle();

    verify(mockAuthService.signInWithEmailAndPassword("test@twoaxis.org", "password123")).called(1);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);

  });
  testWidgets("Should show an AlertDialog on invalid password", (WidgetTester tester) async {

    when(mockAuthService.signInWithEmailAndPassword(any, any)).thenThrow(FirebaseAuthException(code: "invalid-credential"));

    GetIt.I.registerSingleton<AuthService>(mockAuthService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Login"));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(find.byKey(Key("email")), "test@twoaxis.org");
    await tester.enterText(find.byKey(Key("password")), "password123");

    await tester.tap(find.byKey(Key("login")));
    await tester.pumpAndSettle();

    verify(mockAuthService.signInWithEmailAndPassword("test@twoaxis.org", "password123")).called(1);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);

  });
  testWidgets("Should show an AlertDialog on empty fields", (WidgetTester tester) async {

    GetIt.I.registerSingleton<AuthService>(mockAuthService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Login"));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.tap(find.byKey(Key("login")));
    await tester.pumpAndSettle();

    verifyNever(mockAuthService.signInWithEmailAndPassword("", ""));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);

  });
}