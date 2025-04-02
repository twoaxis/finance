import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/theme.dart';
import '../../../values/spaces.dart';
import '../../common/themed_input_field.dart';

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
          widget.sheet.get("name"),
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
                        Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add an expense.",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Writing down your expenses is the best way to know how much you spend.",
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
                        ThemedInputField(
                          label: "Name",
                          controller: nameController,
                          placeholder: "Mortgage",
                          enabled: !pending,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20),
                        ThemedInputField(
                          label: "Value",
                          controller: valueController,
                          placeholder: "30000",
                          enabled: !pending,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        ThemedInputField(
                          label: "Date",
                          controller: dateController,
                          placeholder: "2025-05-10",
                          enabled: !pending,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          onTap: () => _setDate(context),
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deduct from balance:",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 5),
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
