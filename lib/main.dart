import 'package:financial_planner_mobile/pages/assets.dart';
import 'package:financial_planner_mobile/pages/expenses.dart';
import 'package:financial_planner_mobile/pages/income.dart';
import 'package:financial_planner_mobile/pages/liabilities.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int selected = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Planner',
      theme: ThemeData(
        colorScheme: lightTheme,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: IndexedStack(
          index: selected,
          children: const [
            IncomePage(),
            ExpensesPage(),
            AssetsPage(),
            LiabilitiesPage(),
          ],
        ),
        appBar: AppBar(
          title: const Text("Financial Planner"),
          backgroundColor: lightTheme.surfaceContainer,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selected,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Income"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Expenses"),
            BottomNavigationBarItem(icon: Icon(Icons.house), label: "Assets"),
            BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Liabilities")
          ],
          onTap: (index) {
            setState(() {
              selected = index;
            });
          },
        ),
      )
    );
  }
}