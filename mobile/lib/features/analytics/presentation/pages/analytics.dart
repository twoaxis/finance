import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/core/util/money_format.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  List<FlSpot> generateExpenseSpots(List<dynamic> transactions) {
    var now = DateTime.now();
    var lastWeek = List.generate(
        7, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i)));

    // Initialize a map with zeroes for each day
    Map<String, double> dailyTotals = {
      for (var day in lastWeek) "${day.year}-${day.month}-${day.day}": 0.0,
    };

    for (var tx in transactions) {
      if (tx.type != TransactionType.expense) continue;

      var date = tx.date;
      var dateKey = "${date.year}-${date.month}-${date.day}";

      if (dailyTotals.containsKey(dateKey)) {
        dailyTotals[dateKey] = dailyTotals[dateKey]! + tx.amount;
      }
    }

    // Convert to FlSpot
    List<FlSpot> spots = [];
    for (int i = 0; i < lastWeek.length; i++) {
      var key = "${lastWeek[i].year}-${lastWeek[i].month}-${lastWeek[i].day}";
      spots.add(FlSpot(i.toDouble(), dailyTotals[key]!));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analytics"),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(fullscreenSpacing),
          child: SingleChildScrollView(
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is! UserStateAuthenticated) {
                  return const Center(child: CircularProgressIndicator());
                }

                var user = state.user;

                return Column(
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
                            Builder(builder: (context) {
                              var total = user.assets.fold(0.0, (sum, asset) => sum + asset.value);
                              return Text(
                                formatMoneyWithContext(context, total),
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(
                          color: Theme.of(context).colorScheme.surfaceBright,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Text("Total balance before receivables")),
                            Builder(builder: (context) {
                              var total = user.balances.fold(0.0, (sum, balance) => sum + balance.value);
                              return Text(
                                formatMoneyWithContext(context, total),
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(
                          color: Theme.of(context).colorScheme.surfaceBright,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Text("Total receivables")),
                            Builder(builder: (context) {
                              var total = user.receivables.fold(0.0, (sum, item) => sum + item.value);
                              return Text(
                                formatMoneyWithContext(context, total),
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(
                          color: Theme.of(context).colorScheme.surfaceBright,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Text("Total balance after receivables")),
                            Builder(builder: (context) {
                              var balances = user.balances.fold(0.0, (sum, b) => sum + b.value);
                              var receivables = user.receivables.fold(0.0, (sum, r) => sum + r.value);
                              return Text(
                                formatMoneyWithContext(context, balances + receivables),
                              );
                            }),
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
                    BlocBuilder<TransactionsBloc, TransactionsState>(
                      builder: (context, state) {
                        if (state is! TransactionsStateLoaded) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        var spots = generateExpenseSpots(state.transactions);

                        return SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        if (index < 0 || index >= 7) return SizedBox.shrink();

                                        var date =
                                            DateTime.now().subtract(Duration(days: 6 - index));
                                        return Text("${date.day.toString().padLeft(2, '0')}/${date.month}",
                                            style: TextStyle(color: Colors.white, fontSize: 10));
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        // Only show actual used Y values
                                        var usedY = spots.map((e) => e.y).toSet();
                                        if (usedY.contains(value)) {
                                          return Text(value.toInt().toString(),
                                              style: TextStyle(color: Colors.white, fontSize: 12));
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
                                      colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                                    ),
                                    barWidth: 5,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]
                                            .map((color) => color.withAlpha(77))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainer),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
