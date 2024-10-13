import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        body: const Text("Hello, world!"),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Income"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Expenses"),
            BottomNavigationBarItem(icon: Icon(Icons.house), label: "Assets"),
            BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Liabilities")
          ]
        ),
      )
    );
  }
}