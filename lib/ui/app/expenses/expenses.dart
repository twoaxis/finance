import 'package:financial_planner_mobile/ui/app/expenses/expenses_fixed_screen.dart';
import 'package:financial_planner_mobile/ui/app/expenses/expenses_one_time_screen.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {

  List<dynamic> oneTimeExpenses = [];
  List<dynamic> fixedExpenses = [];
  bool error = false;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((e) {
      setState(() {
        fixedExpenses = e.data()?["fixedExpenses"];
        oneTimeExpenses = e.data()?["expenses"];
      });
    }, onError: (e) {
      setState(() {
        error = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: "One-time"),
                Tab(text: "Fixed"),
              ],
              dividerColor: darkTheme.surfaceContainer,
              indicatorColor: darkTheme.primary,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
                child: TabBarView(
                children: [
                  OneTimeExpensesScreen(expenses: oneTimeExpenses),
                  FixedExpensesScreen(expenses: fixedExpenses),
                ],
            )),
          ],
        ));
  }
}
