import 'dart:math';

import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/cubit/receivables_cubit.dart';
import 'package:financial_planner_mobile/ui/app/dashboard/dashboard_button.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/money_format.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Color _generateColorFromName(String name) {
    final int hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
    final Random random = Random(hash);

    return Color.fromRGBO(
      100 + random.nextInt(255),
      100 + random.nextInt(255),
      100 + random.nextInt(255),
      1,
    );
  }

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
                    BlocBuilder<BalancesCubit, List<dynamic>>(
                      builder: (content, balances) {
                        var total = balances.fold(0, (sum, asset) {
                          double value =
                              double.tryParse(asset["value"].toString()) ?? 0.0;
                          return sum + value.toInt();
                        });
                        return Text(
                          formatMoney(total),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DashboardButton(icon: Icons.add, name: "Quick add"),
                        DashboardButton(icon: Icons.insights, name: "Insights"),
                        DashboardButton(
                            icon: Icons.money_off_csred, name: "Set a budget"),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: fullscreenSpacing),
                      child: Row(
                        children: [
                          Expanded(child: Text("Net worth")),
                          BlocBuilder<AssetsCubit, List<dynamic>>(
                            builder: (content, balances) {
                              var total = balances.fold(0, (sum, asset) {
                                double value =
                                    double.tryParse(asset["value"].toString()) ?? 0.0;
                                return sum + value.toInt();
                              });
                              return Text(
                                formatMoney(total),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      color: darkTheme.surfaceBright,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: fullscreenSpacing),
                      child: Row(
                        children: [
                          Expanded(child: Text("Total receivables")),
                          BlocBuilder<ReceivablesCubit, List<dynamic>>(
                            builder: (content, balances) {
                              var total = balances.fold(0, (sum, asset) {
                                double value =
                                    double.tryParse(asset["value"].toString()) ?? 0.0;
                                return sum + value.toInt();
                              });
                              return Text(
                                formatMoney(total),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      color: darkTheme.surfaceBright,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: fullscreenSpacing),
                      child: Row(
                        children: [
                          Expanded(child: Text("Total liabilities")),
                          BlocBuilder<LiabilitiesCubit, List<dynamic>>(
                            builder: (content, balances) {
                              var total = balances.fold(0, (sum, asset) {
                                double value =
                                    double.tryParse(asset["value"].toString()) ?? 0.0;
                                return sum + value.toInt();
                              });
                              return Text(
                                formatMoney(total),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
