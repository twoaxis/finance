import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/app/theme.dart';
import 'package:twoaxis_finance/app/theme_cubit.dart';
import 'package:twoaxis_finance/features/app_shell/presentation/pages/app_shell.dart';
import 'package:twoaxis_finance/features/auth/data/auth_repository_impl.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_repository.dart';
import 'package:twoaxis_finance/features/transactions/data/transaction_repository_impl.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_repository.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/data/repositories/user_repository_impl.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';
import 'package:twoaxis_finance/features/account/presentation/bloc/account_bloc.dart';
import 'package:twoaxis_finance/features/assets/presentation/bloc/assets_bloc.dart';
import 'package:twoaxis_finance/features/balances/presentation/bloc/balances_bloc.dart';
import 'package:twoaxis_finance/features/bills/presentation/bloc/bills_bloc.dart';
import 'package:twoaxis_finance/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:twoaxis_finance/features/income/presentation/bloc/income_bloc.dart';
import 'package:twoaxis_finance/features/liabilities/presentation/bloc/liabilities_bloc.dart';
import 'package:twoaxis_finance/features/receivables/presentation/bloc/receivables_bloc.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/version/presentation/cubit/version_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
              firebaseAuth: FirebaseAuth.instance,
              firestore: FirebaseFirestore.instance),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepositoryImpl(
            firestore: FirebaseFirestore.instance,
            auth: FirebaseAuth.instance,
          ),
        ),
        RepositoryProvider<TransactionRepository>(
          create: (context) => TransactionRepositoryImpl(
            firestore: FirebaseFirestore.instance,
            auth: FirebaseAuth.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
          BlocProvider(
            create: (context) => VersionCubit(),
          ),
          BlocProvider(
            create: (context) => UserCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => TransactionsBloc(
              transactionRepository: context.read<TransactionRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AccountBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => IncomeBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BalancesBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AssetsBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BillsBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BudgetBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ReceivablesBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => LiabilitiesBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "TwoAxis Finance",
              themeMode: mode,
              theme: ThemeData(
                splashFactory: NoSplash.splashFactory,
                colorScheme: appLightTheme,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                splashFactory: NoSplash.splashFactory,
                colorScheme: appDarkTheme,
                useMaterial3: true,
              ),
              home: const AppShell(),
            );
          },
        ),
      ),
    );
  }
}
