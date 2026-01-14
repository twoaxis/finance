import 'package:financial_planner_mobile/app_observer.dart';
import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/cubit/bills_cubit.dart';
import 'package:financial_planner_mobile/cubit/budget_cubit.dart';
import 'package:financial_planner_mobile/cubit/currency_cubit.dart';
import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/cubit/name_cubit.dart';
import 'package:financial_planner_mobile/cubit/receivables_cubit.dart';
import 'package:financial_planner_mobile/cubit/transactions_cubit.dart';
import 'package:financial_planner_mobile/features/app.dart';
import 'package:financial_planner_mobile/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_planner_mobile/core/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    // TODO: Remove this in production
    await FirebaseAuth.instance
        .setSettings(appVerificationDisabledForTesting: true);

    // await FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9099);
    // FirebaseFirestore.instance.useFirestoreEmulator("10.0.2.2", 8080);
  }

  Bloc.observer = MyBlocObserver();

  runApp(
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
        BlocProvider(
          create: (context) => NameCubit(),
        ),
        BlocProvider(
          create: (context) => TransactionsCubit(),
        ),
        BlocProvider(
          create: (context) => BillsCubit(),
        ),
        BlocProvider(
          create: (context) => BudgetCubit(),
        ),
        BlocProvider(
          create: (context) => CurrencyCubit(),
        ),
      ],
      child: const FinancialPlanner(),
    ),
  );
}

class FinancialPlanner extends StatefulWidget {
  const FinancialPlanner({super.key});

  @override
  State<FinancialPlanner> createState() => _FinancialPlannerState();
}

class _FinancialPlannerState extends State<FinancialPlanner> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        loggedIn = (user != null);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "TwoAxis Finance",
        theme: ThemeData(
          splashFactory: NoSplash.splashFactory,
          colorScheme: darkTheme,
          useMaterial3: true,
        ),
        home: loggedIn ? const App() : const Onboarding());
  }
}
