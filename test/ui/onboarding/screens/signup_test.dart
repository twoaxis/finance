import 'package:financial_planner_mobile/abstract/auth_service.dart';
import 'package:financial_planner_mobile/abstract/firestore_service.dart';
import 'package:financial_planner_mobile/ui/onboarding/screens/login.dart';
import 'package:financial_planner_mobile/ui/onboarding/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/auth.mocks.dart';
import '../../../mocks/firestore.mocks.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockFirestoreService mockFirestoreService;
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
                  MaterialPageRoute(builder: (_) => SignupPage()),
                );
              },
              child: Text("Go to Signup"),
            ),
          ),
        ),
      ),
    );
  }

  setUp(() {
    mockAuthService = MockAuthService();
    mockFirestoreService = MockFirestoreService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    GetIt.I.reset();
  });


  testWidgets("Should send email verification on success", (WidgetTester tester) async {

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn("123");
    when(mockAuthService.createUserWithEmailAndPassword(any, any)).thenAnswer((_) async => mockUserCredential);

    GetIt.I.registerSingleton<AuthService>(mockAuthService);
    GetIt.I.registerSingleton<FirestoreService>(mockFirestoreService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Signup"));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);

    await tester.enterText(find.byKey(Key("email")), "test@twoaxis.org");
    await tester.enterText(find.byKey(Key("password")), "password123");
    await tester.enterText(find.byKey(Key("repeat-password")), "password123");

    await tester.tap(find.byKey(Key("signup")));
    await tester.pumpAndSettle();

    verify(mockAuthService.createUserWithEmailAndPassword("test@twoaxis.org", "password123")).called(1);
    verify(mockUser.sendEmailVerification()).called(1);

    expect(find.byType(SignupPage), findsNothing);

  });


  testWidgets("Should write to Firestore on success", (WidgetTester tester) async {

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn("123");
    when(mockAuthService.createUserWithEmailAndPassword(any, any)).thenAnswer((_) async => mockUserCredential);

    GetIt.I.registerSingleton<AuthService>(mockAuthService);
    GetIt.I.registerSingleton<FirestoreService>(mockFirestoreService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Signup"));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);

    await tester.enterText(find.byKey(Key("email")), "test@twoaxis.org");
    await tester.enterText(find.byKey(Key("password")), "password123");
    await tester.enterText(find.byKey(Key("repeat-password")), "password123");

    await tester.tap(find.byKey(Key("signup")));
    await tester.pumpAndSettle();

    verify(mockAuthService.createUserWithEmailAndPassword("test@twoaxis.org", "password123")).called(1);
    verify(mockFirestoreService.writeEmptyUserData("123")).called(1);

    expect(find.byType(SignupPage), findsNothing);

  });

  testWidgets("Should show an AlertDialog on empty fields", (WidgetTester tester) async {

    GetIt.I.registerSingleton<AuthService>(mockAuthService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Signup"));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);

    await tester.tap(find.byKey(Key("signup")));
    await tester.pumpAndSettle();

    verifyNever(mockAuthService.createUserWithEmailAndPassword("", ""));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(SignupPage), findsOneWidget);

  });

  testWidgets("Should show an AlertDialog on non-matching passwords", (WidgetTester tester) async {

    GetIt.I.registerSingleton<AuthService>(mockAuthService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Signup"));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);

    await tester.enterText(find.byKey(Key("email")), "test@twoaxis.org");
    await tester.enterText(find.byKey(Key("password")), "password123");
    await tester.enterText(find.byKey(Key("repeat-password")), "password");

    await tester.tap(find.byKey(Key("signup")));
    await tester.pumpAndSettle();

    verifyNever(mockAuthService.createUserWithEmailAndPassword("test@twoaxis.org", "password123"));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(SignupPage), findsOneWidget);

  });

  testWidgets("Should show an Alert Dialog on weak password", (WidgetTester tester) async {

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn("123");
    when(mockAuthService.createUserWithEmailAndPassword(any, any)).thenThrow(FirebaseAuthException(code: "weak-password"));

    GetIt.I.registerSingleton<AuthService>(mockAuthService);
    GetIt.I.registerSingleton<FirestoreService>(mockFirestoreService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Signup"));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);

    await tester.enterText(find.byKey(Key("email")), "test@twoaxis.org");
    await tester.enterText(find.byKey(Key("password")), "1");
    await tester.enterText(find.byKey(Key("repeat-password")), "1");

    await tester.tap(find.byKey(Key("signup")));
    await tester.pumpAndSettle();

    verify(mockAuthService.createUserWithEmailAndPassword("test@twoaxis.org", "1")).called(1);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(SignupPage), findsOneWidget);

  });
  testWidgets("Should show an Alert Dialog on email already used", (WidgetTester tester) async {

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn("123");
    when(mockAuthService.createUserWithEmailAndPassword(any, any)).thenThrow(FirebaseAuthException(code: "email-already-in-use"));

    GetIt.I.registerSingleton<AuthService>(mockAuthService);
    GetIt.I.registerSingleton<FirestoreService>(mockFirestoreService);

    await setupWidget(tester);

    await tester.tap(find.text("Go to Signup"));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);

    await tester.enterText(find.byKey(Key("email")), "test@twoaxis.org");
    await tester.enterText(find.byKey(Key("password")), "1");
    await tester.enterText(find.byKey(Key("repeat-password")), "1");

    await tester.tap(find.byKey(Key("signup")));
    await tester.pumpAndSettle();

    verify(mockAuthService.createUserWithEmailAndPassword("test@twoaxis.org", "1")).called(1);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(SignupPage), findsOneWidget);

  });
}