import 'package:financial_planner_mobile/cubit/transactions_cubit.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../util/money_format.dart';
import '../../../util/theme.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  Map<String, List<dynamic>> groupTransactionsByDate(List<dynamic> transactions) {
    Map<String, List<dynamic>> grouped = {};

    for (var tx in transactions) {
      String dateKey = DateFormat('MMM d, y').format(tx["date"].toDate());
      //String dateKey = "${tx["date"].toDate().year}-${tx["date"].toDate().month.toString().padLeft(2, '0')}-${tx["date"].toDate().day.toString().padLeft(2, '0')}";

      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }

      grouped[dateKey]!.add(tx);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        backgroundColor: darkTheme.surfaceContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(fullscreenSpacing),
          child: BlocBuilder<TransactionsCubit, List<dynamic>>(
            builder: (BuildContext context, List<dynamic> transactions) {
              final grouped = groupTransactionsByDate(transactions);

              final sortedKeys = grouped.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return ListView.separated(
                itemCount: sortedKeys.length,
                itemBuilder: (BuildContext context, int index) {
                  final dateKey = sortedKeys[index];
                  final txList = grouped[dateKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateKey,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10,),
                      ...txList.map((tx) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            spacing: 20,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: darkTheme.surfaceBright,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    if (tx["type"] == "expense")
                                      Icon(
                                        Icons.payments_rounded,
                                        size: 25,
                                      )
                                    else if (tx["type"] ==
                                        "income")
                                      Icon(
                                        Icons.file_download_rounded,
                                        size: 25,
                                      )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tx["name"]),
                                    Text(
                                        DateFormat('MMM d, y. hh:mm a').format(tx["date"].toDate()),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey))
                                  ],
                                ),
                              ),
                              if (tx["type"] == "expense")
                                Text(
                                  "-${formatMoney(tx["value"])}",
                                  style: TextStyle(
                                      color: darkTheme.primary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )
                              else if (tx["type"] == "income")
                                Text(
                                  "+${formatMoney(tx["value"])}",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )
                            ],
                          ),
                        );
                      })
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                      color: darkTheme.surfaceBright, height: 30);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
