import 'package:twoaxis_finance/features/budget/presentation/pages/budget_setup.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/util/money_format.dart';
import 'package:twoaxis_finance/app/theme.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/features/budget/presentation/widgets/budget_info.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget"),
        backgroundColor: darkTheme.surfaceContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(fullscreenSpacing),
          child: Column(
            children: [
              Expanded(child: BlocBuilder<UserCubit, UserState>(
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
                          SizedBox(height: 20,),
                          Opacity(
                            opacity: 0.3,
                            child: Text("No budget set", style: TextStyle(fontSize: 25),),
                          )
                        ],
                      ),
                    );
                  }

                  var limit = budget.value;
                  var spent = budget.spent;
                  var percent = spent / limit;

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
              )),
              PrimaryButton(text: "Set budget", onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetSetup()));
              })
            ],
          ),
        ),
      ),
    );
  }
}
