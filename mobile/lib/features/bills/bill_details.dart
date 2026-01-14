import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/features/bills/bill_payment.dart';
import 'package:financial_planner_mobile/core/widgets/primary_button.dart';
import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/utils/money_format.dart';
import '../../core/theme/theme.dart';

class BillDetails extends StatefulWidget {
  const BillDetails({super.key, required this.index, required this.bill});

  final int index;
  final Map bill;

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  bool pending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill details"),
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
                        widget.bill["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Text(
                      formatMoneyWithContext(context, widget.bill["value"]),
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
                  text: "Pay bill",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillPayment(
                          bill: widget.bill,
                          index: widget.index,
                        ),
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
                                      "Are you sure to delete this bill?"),
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
                                                "bills": FieldValue.arrayRemove(
                                                    [widget.bill])
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
                      "Delete bill",
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
