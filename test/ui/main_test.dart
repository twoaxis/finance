import 'package:financial_planner_mobile/abstract/auth_service.dart';
import 'package:financial_planner_mobile/abstract/firestore_service.dart';
import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/cubit/receivables_cubit.dart';
import 'package:financial_planner_mobile/main.dart';
import 'package:financial_planner_mobile/ui/app/app.dart';
import 'package:financial_planner_mobile/ui/onboarding/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../mocks/auth.mocks.dart';
import '../mocks/firestore.mocks.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockFirestoreService mockFirestoreService;
  late MockUser mockUser;

  setup(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => IncomeCubit(),
          ),
          BlocProvider(
            create: (context) => ExpensesCubit(),
          ),
          BlocProvider(
            create: (context) => AssetsCubit(),
          ),
          BlocProvider(
            create: (context) => BalancesCubit(),
          ),
          BlocProvider(
            create: (context) => LiabilitiesCubit(),
          ),
          BlocProvider(
            create: (context) => ReceivablesCubit(),
          ),
        ],
        child: const FinancialPlanner(),
      ),
    );
  }

  setUp(() {
    mockAuthService = MockAuthService();
    mockFirestoreService = MockFirestoreService();
    mockUser = MockUser();

    GetIt.I.reset();
  });

  testWidgets("Should open app when logged in", (WidgetTester tester) async {
    when(mockAuthService.authStateChanges())
        .thenAnswer((_) => Stream<User?>.value(mockUser));
    when(mockFirestoreService.listenToUserData(any))
        .thenAnswer((_) => Stream.empty());
    when(mockFirestoreService.listenToUserExpenses(any))
        .thenAnswer((_) => Stream.empty());

    when(mockAuthService.getCurrentUser()).thenReturn(mockUser);

    when(mockUser.uid).thenReturn("abc123");
    when(mockUser.email).thenReturn("test@twoaxis.org");

    GetIt.I.registerSingleton<AuthService>(mockAuthService);
    GetIt.I.registerSingleton<FirestoreService>(mockFirestoreService);

    await setup(tester);
    await tester.pumpAndSettle();

    expect(find.byType(App), findsOneWidget);
    expect(find.byType(Onboarding), findsNothing);
  });

  testWidgets("Should open onboarding when not logged in", (WidgetTester tester) async {
    when(mockAuthService.authStateChanges())
        .thenAnswer((_) => Stream<User?>.value(null));

    GetIt.I.registerSingleton<AuthService>(mockAuthService);;

    await setup(tester);
    await tester.pumpAndSettle();

    expect(find.byType(App), findsNothing);
    expect(find.byType(Onboarding), findsOneWidget);
  });
}
