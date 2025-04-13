import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/ui/common/themed_input_field.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/balances_cubit.dart';
import '../../common/primary_button.dart';

class LiabilityPayment extends StatefulWidget {
  const LiabilityPayment({super.key, required this.liability, required this.liabilityIndex});

  final Map liability;
  final int liabilityIndex;

  @override
  State<LiabilityPayment> createState() => _LiabilityPaymentState();
}

class _LiabilityPaymentState extends State<LiabilityPayment> {
  bool pending = false;
  TextEditingController valueController = TextEditingController();
  int balanceIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.liability["name"]),
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
                                      "Pay liability",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Pay part or all of your liability.",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.card_travel,
                                size: 100,
                                color: darkTheme.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          ThemedInputField(
                            label: "Value",
                            controller: valueController,
                            placeholder: "2000",
                            enabled: !pending,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 30),
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
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  text: "Pay liability",
                  enabled: !pending,
                  onPressed: () async {
                    setState(() {
                      pending = true;
                    });
                    try {

                      if (valueController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Please fill all fields"),
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
                      } else if (double.parse(valueController.text) < 0) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Value cannot be negative."),
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
                      } else {
                        context.read<LiabilitiesCubit>().state[widget.liabilityIndex]["value"] -= double.parse(valueController.text);

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .update({"liabilities": context.read<LiabilitiesCubit>().state});

                        if(balanceIndex != -1) {
                          balances[balanceIndex]["value"] -= double.parse(valueController.text);
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({"balances": balances});
                        }

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection("transactions")
                            .add(
                          {
                            "type": "expense",
                            "name": widget.liability["name"],
                            "value": double.parse(valueController.text),
                            "date": DateTime.now(),
                            "source": balanceIndex != -1 ? balances[balanceIndex]["name"] : null
                          },
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      }

                    } on FormatException {
                      if (context.mounted) {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Value must be an number."),
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
                    }  on Exception {
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
