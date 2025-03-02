import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/cubit/fixed_expenses_cubit.dart';
import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/cubit/receivables_cubit.dart';
import 'package:financial_planner_mobile/ui/app/assets/assets.dart';
import 'package:financial_planner_mobile/ui/app/expense_sheets/expense_sheets.dart';
import 'package:financial_planner_mobile/ui/app/expense_sheets/expense_sheets_action_button.dart';
import 'package:financial_planner_mobile/ui/app/income/income.dart';
import 'package:financial_planner_mobile/ui/app/info/info.dart';
import 'package:financial_planner_mobile/ui/app/liabilities/liabilities.dart';
import 'package:financial_planner_mobile/ui/app/income/income_action_button.dart';
import 'package:financial_planner_mobile/ui/app/liabilities/liabilities_action_button.dart';
import 'package:financial_planner_mobile/ui/app/receivables/receivables.dart';
import 'package:financial_planner_mobile/ui/app/receivables/receivables_action_button.dart';
import 'package:financial_planner_mobile/ui/app/settings/settings.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'assets/asset_action_button.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selected = 0;

  final List<String> nameList = [
    'Income',
    'Expense Sheets',
    'Assets',
    'Liabilities',
    'Receivables'
  ];

  final List<List<Widget>?> buttonList = [
    [const IncomeActionButton()],
    [const ExpenseSheetsActionButtonAdd()],
    [const AssetActionButton()],
    [const LiabilitiesActionButton()],
    [const ReceivablesActionButton()]
  ];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((e) {
      if (mounted) {
        context.read<IncomeCubit>().updateIncome(e.data()?["income"] ?? []);

        context
            .read<FixedExpensesCubit>()
            .updateFixedExpenses(e.data()?["fixedExpenses"] ?? []);
        context.read<AssetsCubit>().updateAssets(e.data()?["assets"] ?? []);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selected,
        children: const [
          IncomePage(),
          ExpenseSheetsPage(),
          AssetsPage(),
          LiabilitiesPage(),
          ReceivablesPage()
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
                  title: Text("Expense Sheets"),
                  leading: Icon(Icons.edit_document,
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
                ),
                ListTile(
                  title: Text("Receivables"),
                  leading: Icon(Icons.request_quote,
                      color: darkTheme.onSurfaceVariant),
                  onTap: () {
                    setState(() {
                      selected = 4;
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
