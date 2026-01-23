import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twoaxis_finance/cubit/assets_cubit.dart';
import 'package:twoaxis_finance/cubit/balances_cubit.dart';
import 'package:twoaxis_finance/cubit/bills_cubit.dart';
import 'package:twoaxis_finance/cubit/budget_cubit.dart';
import 'package:twoaxis_finance/cubit/currency_cubit.dart';
import 'package:twoaxis_finance/cubit/expenses_cubit.dart';
import 'package:twoaxis_finance/cubit/income_cubit.dart';
import 'package:twoaxis_finance/cubit/liabilities_cubit.dart';
import 'package:twoaxis_finance/cubit/name_cubit.dart';
import 'package:twoaxis_finance/cubit/receivables_cubit.dart';
import 'package:twoaxis_finance/cubit/transactions_cubit.dart';
import 'package:twoaxis_finance/ui/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if(kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9099);
    FirebaseFirestore.instance.useFirestoreEmulator("10.0.2.2", 8080);
  }

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
      child: const App(),
    ),
  );
}
