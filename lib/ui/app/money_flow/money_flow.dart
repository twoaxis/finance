import 'package:financial_planner_mobile/ui/app/bills/bills.dart';
import 'package:financial_planner_mobile/ui/app/budget/budget_info.dart';
import 'package:financial_planner_mobile/ui/app/liabilities/liabilities.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/budget_cubit.dart';
import '../../../util/money_format.dart';
import '../budget/budget.dart';

class MoneyFlowPage extends StatelessWidget {
  const MoneyFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(fullscreenSpacing),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Money Flow",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillsPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: darkTheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(Icons.edit_document, size: 50, color: darkTheme.primary,),
                            Text("Bills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LiabilitiesPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: darkTheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(Icons.card_travel, size: 50, color: darkTheme.primary,),
                            Text("Liabilities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetPage()));

                },
                child: Text(
                  "Budget",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ),
              SizedBox(height: 20),
              BlocBuilder<BudgetCubit, dynamic>(
                builder: (context, budget) {
                  if (budget == null) {
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
                          SizedBox(height: 20,),
                          Opacity(
                            opacity: 0.3,
                            child: Text("No budget set", style: TextStyle(fontSize: 25),),
                          )
                        ],
                      ),
                    );
                  }

                  final limit = budget["value"];
                  final spent = budget["spent"];
                  final percent = (spent / limit);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: percent,
                              strokeWidth: 100,
                              backgroundColor: darkTheme.surfaceBright,
                              color: percent < 0.75
                                  ? Colors.green
                                  : percent < 1
                                  ? Colors.orange
                                  : Color(0xFFAA0000),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${(percent * 100).toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.bold)),
                                const Text("used"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BudgetInfo(
                              label: "Limit",
                              value: formatMoney(limit)),
                          BudgetInfo(
                              label: "Spent",
                              value: formatMoney(spent)),
                          BudgetInfo(
                            label: "Remaining",
                            value: formatMoney(limit > spent ? limit - spent : 0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (percent >= 1)
                        const Text("You've exceeded your budget!",
                            style: TextStyle(color: Colors.red)),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
