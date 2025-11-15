import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/budget_cubit.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/balances_cubit.dart';
import '../../common/primary_button.dart';

class BillPayment extends StatefulWidget {
  const BillPayment({super.key, required this.bill, required this.index});

  final Map bill;
  final int index;

  @override
  State<BillPayment> createState() => _BillPaymentState();
}

class _BillPaymentState extends State<BillPayment> {
  bool pending = false;
  int balanceIndex = -1;
  bool addToBudget = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bill["name"]),
      ),
      body: SafeArea(
        child: BlocBuilder<BalancesCubit, List<dynamic>>(
            builder: (BuildContext context, List<dynamic> balances) {
          var menuEntries = balances.map((balance) {
            return DropdownMenuEntry(
                value: balances.indexOf(balance), label: balance["name"]);
          }).toList();

          return Padding(
            padding: EdgeInsets.all(fullscreenSpacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pay bill",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Automatically deducts from balance and creates an expense.",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.edit_document,
                                size: 100,
                                color: darkTheme.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deduct from balance:",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                child: DropdownMenu(
                                  width: double.infinity,
                                  initialSelection: -1,
                                  inputDecorationTheme: InputDecorationTheme(
                                    filled: true,
                                    fillColor: darkTheme.surfaceContainer,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                      gapPadding: 0,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                      gapPadding: 0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                      gapPadding: 0,
                                    ),
                                  ),
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(
                                        value: -1,
                                        label: "Do not deduct"),
                                    ...menuEntries
                                  ],
                                  onSelected: (value) {
                                    setState(() {
                                      balanceIndex = value!;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          BlocBuilder<BudgetCubit, dynamic>(builder: (context, state) {
                            if(state != null) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    addToBudget = !addToBudget;
                                  });
                                },
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: addToBudget ? darkTheme.primary : darkTheme.surfaceContainer,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: addToBudget ? Icon(Icons.check) : null,
                                    ),
                                    Text("Add to budget")
                                  ],
                                ),
                              );
                            }
                            return SizedBox();
                          })
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  text: "Pay bill",
                  enabled: !pending,
                  onPressed: () async {
                    setState(() {
                      pending = true;
                    });
                    try {
                        if(balanceIndex != -1) {
                          balances[balanceIndex]["value"] -= widget.bill["value"];
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({"balances": balances});
                        }
                        if(context.mounted && context.read<BudgetCubit>().state != null && addToBudget) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update(
                            {
                              "budget": {
                                "spent": context.read<BudgetCubit>().state["spent"] + widget.bill["value"],
                                "value": context.read<BudgetCubit>().state["value"]
                              }
                            },
                          );
                        }

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection("transactions")
                            .add(
                          {
                            "type": "expense",
                            "name": widget.bill["name"],
                            "value":widget.bill["value"],
                            "date": DateTime.now(),
                            "source": balanceIndex != -1 ? balances[balanceIndex]["name"] : null
                          },
                        );

                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }

                    } on Exception {
                      if (context.mounted) {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("An unknown error has occurred"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Okay"),
                                )
                              ],
                            );
                          },
                        );
                      }
                    } finally {
                      setState(() {
                        pending = false;
                      });
                    }
                  },
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
