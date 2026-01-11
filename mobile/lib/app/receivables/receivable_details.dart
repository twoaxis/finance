import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/app/receivables/receivable_payout.dart';
import 'package:financial_planner_mobile/core/widgets/primary_button.dart';
import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/utils/money_format.dart';
import '../../core/theme/theme.dart';

class ReceivableDetails extends StatefulWidget {
  const ReceivableDetails(
      {super.key, required this.index, required this.receivable});

  final int index;
  final Map receivable;

  @override
  State<ReceivableDetails> createState() => _ReceivableDetailsState();
}

class _ReceivableDetailsState extends State<ReceivableDetails> {
  bool pending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receivable details"),
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
                        widget.receivable["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Text(
                      formatMoneyWithContext(
                          context, widget.receivable["value"]),
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
                  text: "Pay",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceivablePay(
                            index: widget.index, receivable: widget.receivable),
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
                                      "Are you sure to delete this receivable?"),
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
                                                "receivables":
                                                    FieldValue.arrayRemove(
                                                        [widget.receivable])
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
                      "Delete receivable",
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
