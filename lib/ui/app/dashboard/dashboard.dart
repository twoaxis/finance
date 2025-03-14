import 'dart:math';

import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/util/theme.dart';
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: darkTheme.surfaceContainer,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: BlocBuilder<AssetsCubit, List<dynamic>>(
                  builder: (BuildContext context, List<dynamic> assets) {
                    var total = assets.fold(0, (sum, asset) {
                      double value =
                          double.tryParse(asset["value"].toString()) ?? 0.0;
                      return sum + value.toInt();
                    });
                    var sections = assets.map((asset) {
                      double value =
                          double.tryParse(asset["value"].toString()) ?? 0.0;
                      double percentage = total > 0 ? (value / total) * 100 : 0;

                      return PieChartSectionData(
                        title: asset["name"],
                        showTitle: percentage > 5,
                        value: value.toDouble(),
                        color: _generateColorFromName(asset["name"]),
                      );
                    }).toList();
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Net worth",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              formatMoney(total),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: assets.isNotEmpty
                              ? PieChart(
                                  PieChartData(
                                    sections: sections,
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 100,
                                  ),
                                )
                              : Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    'asset/images/empty_data.png',
                                    width: 200,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
