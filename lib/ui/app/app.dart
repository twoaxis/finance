import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/cubit/bills_cubit.dart';
import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/cubit/name_cubit.dart';
import 'package:financial_planner_mobile/cubit/receivables_cubit.dart';
import 'package:financial_planner_mobile/cubit/transactions_cubit.dart';
import 'package:financial_planner_mobile/ui/app/account/account.dart';
import 'package:financial_planner_mobile/ui/app/dashboard/dashboard.dart';
import 'package:financial_planner_mobile/ui/app/money_flow/money_flow.dart';
import 'package:financial_planner_mobile/ui/app/wallet/wallet.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selected = 0;

  @override
  void initState() {
    super.initState();

    context
        .read<NameCubit>()
        .updateName(FirebaseAuth.instance.currentUser!.displayName);

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((e) {
      if (mounted) {
        context.read<IncomeCubit>().updateIncome(e.data()?["income"] ?? []);
        context.read<AssetsCubit>().updateAssets(e.data()?["assets"] ?? []);
        context.read<BillsCubit>().updateBills(e.data()?["bills"] ?? []);
        context
            .read<BalancesCubit>()
            .updateBalances(e.data()?["balances"] ?? []);
        context
            .read<LiabilitiesCubit>()
            .updateLiabilities(e.data()?["liabilities"] ?? []);

        context
            .read<ReceivablesCubit>()
            .updateReceivables(e.data()?["receivables"] ?? []);
      }
    }, onError: (e) {
      if (mounted) {}
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("expenses")
        .snapshots()
        .listen((e) {
      if (mounted) {
        context.read<ExpensesCubit>().updateExpenses(e.docs);
      }
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("transactions")
        .orderBy("date", descending: true)
        .snapshots()
        .listen((e) {
      if (mounted) {
        context.read<TransactionsCubit>().updateTransactions(e.docs);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selected,
        children: const [
          DashboardPage(),
          MoneyFlowPage(),
          Wallet(),
          AccountPage()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: darkTheme.surfaceBright, width: 1), // Top border
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selected,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: darkTheme.primary,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Color(0x44FFFFFF),
          onTap: (page) {
            setState(() {
              selected = page;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
        ),
      ),
    );
  }
}
