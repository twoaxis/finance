import 'package:twoaxis_finance/features/bills/presentation/pages/bills.dart';
import 'package:twoaxis_finance/features/budget/presentation/widgets/budget_info.dart';
import 'package:twoaxis_finance/features/liabilities/presentation/pages/liabilities.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/core/util/money_format.dart';
import 'package:twoaxis_finance/features/budget/presentation/pages/budget.dart';

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
              const Text(
                "Money Flow",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              const SizedBox(height: 20),
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
                            builder: (context) => const BillsPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(Icons.edit_document, size: 50, color: Theme.of(context).colorScheme.primary,),
                            const Text("Bills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LiabilitiesPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(Icons.card_travel, size: 50, color: Theme.of(context).colorScheme.primary,),
                            const Text("Liabilities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BudgetPage()));

                },
                child: const Text(
                  "Budget",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state is! UserStateAuthenticated) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var budget = state.user.budget;

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
                          const SizedBox(height: 20,),
                          const Opacity(
                            opacity: 0.3,
                            child: Text("No budget set", style: TextStyle(fontSize: 25),),
                          )
                        ],
                      ),
                    );
                  }

                  var limit = budget.value;
                  var spent = budget.spent;
                  var percent = limit > 0 ? spent / limit : 0.0;

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
                              value: percent > 1.0 ? 1.0 : percent,
                              strokeWidth: 100,
                              backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                              color: percent < 0.75
                                  ? Colors.green
                                  : percent < 1
                                  ? Colors.orange
                                  : const Color(0xFFAA0000),
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
                              value: formatMoneyWithContext(context, limit)),
                          BudgetInfo(
                              label: "Spent",
                              value: formatMoneyWithContext(context, spent)),
                          BudgetInfo(
                            label: "Remaining",
                            value: formatMoneyWithContext(context, limit > spent ? limit - spent : 0),
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
