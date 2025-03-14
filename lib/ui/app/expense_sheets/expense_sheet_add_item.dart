import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/theme.dart';
import '../../../values/spaces.dart';

class ExpenseSheetAddItem extends StatefulWidget {
  const ExpenseSheetAddItem({super.key, required this.sheet});

  final DocumentSnapshot sheet;

  @override
  State<ExpenseSheetAddItem> createState() => _ExpenseSheetAddItemState();
}

class _ExpenseSheetAddItemState extends State<ExpenseSheetAddItem> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int balanceIndex = -1;
  bool isFixed = false;
  DateTime? dateTime;

  void _setDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        dateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a new expense",
        ),
      ),
      body: SafeArea(
        child: Padding(
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
                        TextField(
                          enabled: !pending,
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Groceries",
                            labelText: "Name",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: darkTheme.surfaceBright),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          enabled: !pending,
                          controller: valueController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "200",
                            labelText: "Value",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: darkTheme.surfaceBright),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Date",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: darkTheme.surfaceBright),
                            ),
                          ),
                          onTap: () => _setDate(context),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<BalancesCubit, List<dynamic>>(
                          builder:
                              (BuildContext context, List<dynamic> balances) {
                            var menuEntries = balances.map((balance) {
                              return DropdownMenuEntry(
                                  value: balances.indexOf(balance),
                                  label: balance["name"]);
                            }).toList();
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  child: DropdownMenu(
                                    width: double.infinity,
                                    label: Text("Deduct from balance"),
                                    initialSelection: -1,
                                    dropdownMenuEntries: [
                                      DropdownMenuEntry(
                                          value: -1, label: "Do not deduct"),
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
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                text: "Add expense",
                enabled: !pending,
                onPressed: () async {
                  setState(() {
                    pending = true;
                  });
                  try {
                    if (nameController.text.isEmpty ||
                        valueController.text.isEmpty) {
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
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection("expenses")
                          .doc(widget.sheet.id)
                          .update(
                        {
                          "expenses": FieldValue.arrayUnion([
                            {
                              "name": nameController.text,
                              "value": double.parse(valueController.text),
                              "date": dateTime
                            }
                          ])
                        },
                      );

                      if (balanceIndex != -1 && context.mounted) {
                        context.read<BalancesCubit>().state[balanceIndex]
                            ["value"] -= double.parse(valueController.text);

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .update({
                          "balances": context.read<BalancesCubit>().state
                        });
                      }

                      nameController.clear();
                      valueController.clear();
                      setState(() {
                        isFixed = false;
                      });
                      if (context.mounted) {
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
        ),
      ),
    );
  }
}
