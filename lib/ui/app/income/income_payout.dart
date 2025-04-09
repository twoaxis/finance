import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/ui/common/themed_input_field.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/balances_cubit.dart';
import '../../common/primary_button.dart';

class IncomePayout extends StatefulWidget {
  const IncomePayout({super.key, required this.income});

  final Map income;

  @override
  State<IncomePayout> createState() => _IncomePayoutState();
}

class _IncomePayoutState extends State<IncomePayout> {
  bool pending = false;
  int balanceIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.income["name"]),
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
                                      "Payout Income Source",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Adding money from this income to your balance.",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
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
                          SizedBox(height: 40),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                child: DropdownMenu(
                                  width: double.infinity,
                                  initialSelection: -1,
                                  hintText: menuEntries.isNotEmpty
                                      ? "Select balance"
                                      : "Add a balance first",
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
                                  dropdownMenuEntries: [...menuEntries],
                                  onSelected: (value) {
                                    setState(() {
                                      balanceIndex = value!;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  text: "Payout Income Source",
                  enabled: !pending && balanceIndex != -1,
                  onPressed: () async {
                    setState(() {
                      pending = true;
                    });
                    try {
                      balances[balanceIndex]["value"] += widget.income["value"];

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update({"balances": balances});

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection("transactions")
                          .add(
                        {
                          "type": "income",
                          "name": widget.income["name"],
                          "value": widget.income["value"],
                          "date": DateTime.now(),
                          "source": balances[balanceIndex]["name"]
                        },
                      );
                      if (context.mounted) {
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
