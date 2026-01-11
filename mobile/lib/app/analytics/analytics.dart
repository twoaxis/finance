import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/assets_cubit.dart';
import '../../cubit/balances_cubit.dart';
import '../../cubit/receivables_cubit.dart';
import '../../cubit/transactions_cubit.dart';
import '../../core/utils/money_format.dart';
import '../../core/theme/theme.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  List<FlSpot> generateExpenseSpots(List<dynamic> transactions) {
    final now = DateTime.now();
    final lastWeek = List.generate(
        7,
        (i) => DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: 6 - i)));

    // Initialize a map with zeroes for each day
    final Map<String, double> dailyTotals = {
      for (var day in lastWeek) "${day.year}-${day.month}-${day.day}": 0.0,
    };

    for (var tx in transactions) {
      if (tx["type"] != "expense") continue;

      final date = tx["date"].toDate();
      final dateKey = "${date.year}-${date.month}-${date.day}";

      if (dailyTotals.containsKey(dateKey)) {
        dailyTotals[dateKey] = dailyTotals[dateKey]! + tx["value"];
      }
    }

    // Convert to FlSpot
    List<FlSpot> spots = [];
    for (int i = 0; i < lastWeek.length; i++) {
      final key = "${lastWeek[i].year}-${lastWeek[i].month}-${lastWeek[i].day}";
      spots.add(FlSpot(i.toDouble(), dailyTotals[key]!));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analytics"),
        backgroundColor: darkTheme.surfaceContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(fullscreenSpacing),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Overview",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("Net worth")),
                        BlocBuilder<AssetsCubit, List<dynamic>>(
                          builder: (content, balances) {
                            var total = balances.fold(0, (sum, asset) {
                              double value =
                                  double.tryParse(asset["value"].toString()) ??
                                      0.0;
                              return sum + value.toInt();
                            });
                            return Text(
                              formatMoneyWithContext(context, total),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(
                      color: darkTheme.surfaceBright,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Total balance before receivables")),
                        BlocBuilder<BalancesCubit, List<dynamic>>(
                          builder: (content, balances) {
                            var total = balances.fold(0, (sum, asset) {
                              double value =
                                  double.tryParse(asset["value"].toString()) ??
                                      0.0;
                              return sum + value.toInt();
                            });
                            return Text(
                              formatMoneyWithContext(context, total),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(
                      color: darkTheme.surfaceBright,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text("Total receivables")),
                        BlocBuilder<ReceivablesCubit, List<dynamic>>(
                          builder: (content, balances) {
                            var total = balances.fold(0, (sum, asset) {
                              double value =
                                  double.tryParse(asset["value"].toString()) ??
                                      0.0;
                              return sum + value.toInt();
                            });
                            return Text(
                              formatMoneyWithContext(context, total),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(
                      color: darkTheme.surfaceBright,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Total balance after receivables")),
                        BlocBuilder<ReceivablesCubit, List<dynamic>>(
                          builder: (content, balances) {
                            var receivables = balances.fold(0, (sum, asset) {
                              double value =
                                  double.tryParse(asset["value"].toString()) ??
                                      0.0;
                              return sum + value.toInt();
                            });
                            return BlocBuilder<BalancesCubit, List<dynamic>>(
                              builder: (content, balances) {
                                var balance = balances.fold(0, (sum, asset) {
                                  double value = double.tryParse(
                                          asset["value"].toString()) ??
                                      0.0;
                                  return sum + value.toInt();
                                });
                                return Text(
                                  formatMoneyWithContext(
                                      context, receivables + balance),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 50),
                Text(
                  "Expense Chart",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 30),
                BlocBuilder<TransactionsCubit, List<dynamic>>(
                  builder: (context, transactions) {
                    final spots = generateExpenseSpots(transactions);

                    return SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index < 0 || index >= 7) {
                                      return SizedBox.shrink();
                                    }

                                    final date = DateTime.now()
                                        .subtract(Duration(days: 6 - index));
                                    return Text(
                                        "${date.day.toString().padLeft(2, '0')}/${date.month}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10));
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    // Only show actual used Y values
                                    final usedY = spots.map((e) => e.y).toSet();
                                    if (usedY.contains(value)) {
                                      return Text(value.toInt().toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12));
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                gradient: LinearGradient(
                                  colors: [
                                    darkTheme.primary,
                                    darkTheme.secondary
                                  ],
                                ),
                                barWidth: 5,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      darkTheme.primary,
                                      darkTheme.secondary
                                    ]
                                        .map((color) => color.withAlpha(77))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                            backgroundColor: darkTheme.surfaceContainer),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
