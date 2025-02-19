import 'package:financial_planner_mobile/ui/app/assets/assets.dart';
import 'package:financial_planner_mobile/ui/app/expenses/expenses.dart';
import 'package:financial_planner_mobile/ui/app/expenses/expenses_action_button_add.dart';
import 'package:financial_planner_mobile/ui/app/expenses/expenses_action_button_options.dart';
import 'package:financial_planner_mobile/ui/app/income/income.dart';
import 'package:financial_planner_mobile/ui/app/info/info.dart';
import 'package:financial_planner_mobile/ui/app/liabilities/liabilities.dart';
import 'package:financial_planner_mobile/ui/app/income/income_action_button.dart';
import 'package:financial_planner_mobile/ui/app/liabilities/liabilities_action_button.dart';
import 'package:financial_planner_mobile/ui/app/settings/settings.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'assets/asset_action_button.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selected = 0;

  final List<String> nameList = ['Income', 'Expenses', 'Assets', 'Liabilities'];

  final List<List<Widget>?> buttonList = [
    [const IncomeActionButton()],
    // Income page buttons
    [const ExpensesActionButtonAdd(), const ExpensesActionButtonOptions()],
    // Expenses page buttons
    [const AssetActionButton()],
    // Assets page buttons
    [const LiabilitiesActionButton()]
    // Liabilities page buttons
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selected,
        children: const [
          IncomePage(),
          ExpensesPage(),
          AssetsPage(),
          LiabilitiesPage(),
        ],
      ),
      drawer: Drawer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(color: darkTheme.surfaceContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Logged in as:",
                  style: TextStyle(fontSize: 20),
                ),
                Text(FirebaseAuth.instance.currentUser!.email!)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  title: Text("Income"),
                  leading: Icon(Icons.attach_money,
                      color: darkTheme.onSurfaceVariant),
                  onTap: () {
                    setState(() {
                      selected = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Expenses"),
                  leading: Icon(Icons.shopping_bag,
                      color: darkTheme.onSurfaceVariant),
                  onTap: () {
                    setState(() {
                      selected = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Assets"),
                  leading: Icon(Icons.house, color: darkTheme.onSurfaceVariant),
                  onTap: () {
                    setState(() {
                      selected = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Liabilities"),
                  leading:
                      Icon(Icons.payment, color: darkTheme.onSurfaceVariant),
                  onTap: () {
                    setState(() {
                      selected = 3;
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings, color: darkTheme.onSurfaceVariant),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              "Log out",
              style: const TextStyle(color: Colors.red),
            ),
            leading: Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
          SizedBox(
            height: 50,
          )
        ],
      )),
      appBar: AppBar(
        title: Text(nameList[selected],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: darkTheme.surfaceContainer,
        actions: [
          if (buttonList[selected] != null) ...buttonList[selected]!,
          PopupMenuButton(
            onSelected: (value) async {
              if (value == "info") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InfoPage(),
                  ),
                );
              }
            },
            color: darkTheme.surfaceBright,
            offset: const Offset(0, 50),
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem(
                  value: 'info',
                  child: Text('About'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
