import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/cubit/fixed_expenses_cubit.dart';
import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/cubit/receivables_cubit.dart';
import 'package:financial_planner_mobile/ui/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_planner_mobile/ui/onboarding/onboarding.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
          create: (context) => FixedExpensesCubit(),
        ),
        BlocProvider(
          create: (context) => AssetsCubit(),
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
        title: 'Financial Planner',
        theme: ThemeData(
          colorScheme: darkTheme,
          useMaterial3: true,
        ),
        home: loggedIn ? const App() : const Onboarding());
  }
}
