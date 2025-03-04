import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/cubit/receivables_cubit.dart';
import 'package:financial_planner_mobile/cubit/theme_cubit.dart';
import 'package:financial_planner_mobile/ui/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_planner_mobile/ui/onboarding/onboarding.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
          create: (context) => ThemeCubit(),
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
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final cubit = context.read<ThemeCubit>();
    cubit.isDarkMode(brightness == Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Financial Planner',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state ? ThemeMode.dark : ThemeMode.light,
            home: loggedIn ? const App() : const Onboarding());
      },
    );
  }
}
