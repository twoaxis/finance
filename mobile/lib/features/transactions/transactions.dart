import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/transactions_cubit.dart';
import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/utils/money_format.dart';
import '../../core/theme/theme.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  Map<DateTime, List<dynamic>> groupTransactionsByDate(
      List<dynamic> transactions) {
    Map<DateTime, List<dynamic>> grouped = {};

    for (var tx in transactions) {
      DateTime rawDate = tx["date"].toDate();
      DateTime dateKey =
          DateTime(rawDate.year, rawDate.month, rawDate.day); // remove time

      if (!grouped.containsKey(dateKey)) {
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

              final grouped = groupTransactionsByDate(transactions);

              var sortedKeys = grouped.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return ListView.separated(
                itemCount: sortedKeys.length,
                itemBuilder: (BuildContext context, int index) {
                  final dateKey = sortedKeys.elementAt(index);
                  final txList = grouped[dateKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM d, y')
                            .format(dateKey), // format here only for display
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ...txList.map((tx) {
                        return GestureDetector(
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  height: 180,
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
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid)
                                              .collection("transactions")
                                              .doc(tx.id)
                                              .delete();

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        },
                                        title: Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
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
                                      else if (tx["type"] == "income")
                                        Icon(
                                          Icons.file_download_rounded,
                                          size: 25,
                                        )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(tx["name"]),
                                      Text(
                                          DateFormat('MMM d, y. hh:mm a')
                                              .format(tx["date"].toDate()),
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey))
                                    ],
                                  ),
                                ),
                                if (tx["type"] == "expense")
                                  Text(
                                    "-${formatMoneyWithContext(context, tx["value"])}",
                                    style: TextStyle(
                                        color: darkTheme.primary,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                                else if (tx["type"] == "income")
                                  Text(
                                    "+${formatMoneyWithContext(context, tx["value"])}",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: darkTheme.surfaceBright, height: 30);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
