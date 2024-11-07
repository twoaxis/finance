import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

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
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text("Content for Tab 1")),
                  Center(child: Text("Content for Tab 2")),
                ],
              )
            ),
          ],
        )
    );
  }

}