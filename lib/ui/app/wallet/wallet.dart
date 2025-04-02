import 'package:financial_planner_mobile/ui/app/assets/assets.dart';
import 'package:financial_planner_mobile/ui/app/balances/balances.dart';
import 'package:financial_planner_mobile/ui/app/income/income.dart';
import 'package:financial_planner_mobile/ui/app/receivables/receivables.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/assets_cubit.dart';
import '../../../cubit/balances_cubit.dart';
import '../../../cubit/receivables_cubit.dart';
import '../../../util/money_format.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

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
                "Wallet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IncomePage()));
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: darkTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Income sources",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage your various income sources.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'asset/images/income.png',
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BalancesPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: darkTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Balances",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage your balances.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'asset/images/balances.png',
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReceivablesPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: darkTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receivables",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage money owed to you.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'asset/images/receivables.png',
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AssetsPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: darkTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Assets",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage everything you own.",
                              style:
                              TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'asset/images/assets.png',
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
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
                            formatMoney(total),
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
                      Expanded(child: Text("Total balance before receivables")),
                      BlocBuilder<BalancesCubit, List<dynamic>>(
                        builder: (content, balances) {
                          var total = balances.fold(0, (sum, asset) {
                            double value =
                                double.tryParse(asset["value"].toString()) ??
                                    0.0;
                            return sum + value.toInt();
                          });
                          return Text(
                            formatMoney(total),
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
                            formatMoney(total),
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
                      Expanded(child: Text("Total balance after receivables")),
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
                                formatMoney(receivables + balance),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
