import 'package:financial_planner_mobile/ui/app/expenses/expenses_fixed_screen.dart';
import 'package:financial_planner_mobile/ui/app/expenses/expenses_one_time_screen.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {

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
                OneTimeExpensesScreen(),
                FixedExpensesScreen(),
              ],
            )),
          ],
        ));
  }
}
