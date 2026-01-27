import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/cubit/currency_cubit.dart';
import 'package:financial_planner_mobile/cubit/transactions_cubit.dart';
import 'package:financial_planner_mobile/ui/app/analytics/analytics.dart';
import 'package:financial_planner_mobile/ui/app/budget/budget.dart';
import 'package:financial_planner_mobile/ui/app/dashboard/dashboard_button.dart';
import 'package:financial_planner_mobile/ui/app/quick_add/quick_add_expense.dart';
import 'package:financial_planner_mobile/ui/app/quick_add/quick_add_income.dart';
import 'package:financial_planner_mobile/ui/app/transactions/transactions.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:financial_planner_mobile/util/money_format.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 500, // Extends beyond the App Bar
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [darkTheme.primary, Colors.transparent],
              radius: 1,
              center: Alignment.topCenter,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Text("Total balance"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        BlocBuilder<BalancesCubit, List<dynamic>>(
                          builder: (content, balances) {
                            var total = balances.fold(0, (sum, asset) {
                              double value =
                                  double.tryParse(asset["value"].toString()) ??
                                      0.0;
                              return sum + value.toInt();
                            });
                            if (isHidden) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.5),
                                child: Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: darkTheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              );
                            } else {
                              return Text(
                                formatMoneyWithContext(context, total),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 40),
                              );
                            }
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isHidden = !isHidden;
                            });
                          },
                          color: Colors.white,
                          icon: Icon(isHidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DashboardButton(
                          icon: Icons.add,
                          name: "Quick Add",
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  height: 300,
                                  padding: EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuickAddIncome()));
                                        },
                                        title: Text("Income"),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuickAddExpense()));
                                        },
                                        title: Text("Expense"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        DashboardButton(
                          icon: Icons.analytics,
                          name: "Analytics",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnalyticsPage()));
                          },
                        ),
                        DashboardButton(
                          icon: Icons.money_off_csred,
                          name: "Budget",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BudgetPage()));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionsPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Recent Transactions",
                      style: TextStyle(fontSize: 15),
                    )),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: BlocBuilder<CurrencyCubit, String>(
                  builder: (BuildContext context, String currency) {
                    return BlocBuilder<TransactionsCubit, List<dynamic>>(
                      builder: (BuildContext context, transactions) {
                        if (transactions.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    "assets/images/empty_data.png",
                                    width: 200,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Opacity(
                                  opacity: 0.3,
                                  child: Text(
                                    "No transactions",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: transactions.length <= 30
                              ? transactions.length
                              : 30,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              spacing: 20,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: darkTheme.surfaceBright,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(
                                    getCategoryIcon(
                                      transactions[index]
                                              .data()
                                              .containsKey("category")
                                          ? transactions[index]["category"]
                                          : null,
                                      defaultIcon: transactions[index]
                                                  ["type"] ==
                                              "expense"
                                          ? Icons.payments_rounded
                                          : Icons.file_download_rounded,
                                    ),
                                    size: 25,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(transactions[index]["name"]),
                                      Text(
                                          DateFormat('MMM d, y. hh:mm a')
                                              .format(transactions[index]
                                                      ["date"]
                                                  .toDate()),
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey))
                                    ],
                                  ),
                                ),
                                if (transactions[index]["type"] == "expense")
                                  Text(
                                    "-${formatMoneyWithContext(context, transactions[index]["value"])}",
                                    style: TextStyle(
                                        color: darkTheme.primary,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                                else if (transactions[index]["type"] ==
                                    "income")
                                  Text(
                                    "+${formatMoneyWithContext(context, transactions[index]["value"])}",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                                color: darkTheme.surfaceBright, height: 20);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
