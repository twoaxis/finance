import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/ui/app/income/income_payout.dart';
import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:financial_planner_mobile/util/money_format.dart';
import 'package:financial_planner_mobile/util/theme.dart';

class IncomeDetails extends StatefulWidget {
  const IncomeDetails({super.key, required this.index, required this.income});

  final int index;
  final Map income;

  @override
  State<IncomeDetails> createState() => _IncomeDetailsState();
}

class _IncomeDetailsState extends State<IncomeDetails> {
  bool pending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Income source details"),
        actions: [
          /*IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IncomeEditItem(
                  index: widget.index,
                  income: widget.income,
                ),
              ),
            );
          }, icon: Icon(Icons.edit))*/
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(fullscreenSpacing),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.income["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Text(
                      formatMoneyWithContext(context, widget.income["value"]),
                      style: TextStyle(
                        color: darkTheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                PrimaryButton(
                  text: "Payout",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            IncomePayout(income: widget.income),
                      ),
                    );
                  },
                  enabled: !pending,
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: pending
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (BuildContext build) {
                                return AlertDialog(
                                  title: const Text(
                                      "Are you sure to delete this income source?"),
                                  icon: const Icon(Icons.delete),
                                  actions: [
                                    TextButton(
                                      onPressed: pending
                                          ? null
                                          : () {
                                              Navigator.of(context).pop();
                                            },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: pending
                                          ? null
                                          : () async {
                                              setState(() {
                                                pending = true;
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .update({
                                                "income":
                                                    FieldValue.arrayRemove(
                                                        [widget.income])
                                              });

                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              }
                                            },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              });
                        },
                  child: Center(
                    child: Text(
                      "Delete income source",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
