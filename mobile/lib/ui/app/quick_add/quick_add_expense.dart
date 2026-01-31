import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/ui/common/themed_input_field.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/categories.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:financial_planner_mobile/cubit/balances_cubit.dart';
import 'package:financial_planner_mobile/cubit/budget_cubit.dart';
import 'package:financial_planner_mobile/ui/common/primary_button.dart';

class QuickAddExpense extends StatefulWidget {
  const QuickAddExpense({super.key});

  @override
  State<QuickAddExpense> createState() => _QuickAddExpenseState();
}

class _QuickAddExpenseState extends State<QuickAddExpense> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int balanceIndex = -1;
  DateTime dateTime = DateTime.now();
  bool addToBudget = true;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();

    String date =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    if (hour == 0) hour = 12;

    String time =
        "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";

    setState(() {
      dateController.text = "$date $time";
    });
  }

  void _setDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !context.mounted) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (pickedTime == null) return;

    DateTime fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    String formattedDate =
        "${fullDateTime.day.toString().padLeft(2, '0')}/${fullDateTime.month.toString().padLeft(2, '0')}/${fullDateTime.year}";
    int hour = pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
    String period = pickedTime.period == DayPeriod.am ? "AM" : "PM";
    String formattedTime =
        "${hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')} $period";

    setState(() {
      dateTime = fullDateTime;
      dateController.text = "$formattedDate $formattedTime";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                                      "Add a one-time expense.",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Automatically record the transaction & optionally deduct to your balance.",
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
                                "Category:",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: 8,
                                  children:
                                      expenseCategoryIcons.keys.map((category) {
                                    var isSelected =
                                        selectedCategory == category;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = category;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? darkTheme.primary
                                              : darkTheme.surfaceContainer,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: isSelected
                                              ? null
                                              : Border.all(
                                                  color: Colors.grey.shade700),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 6,
                                          children: [
                                            Icon(
                                              expenseCategoryIcons[category],
                                              size: 18,
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            Text(
                                              category,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ThemedInputField(
                            label: "Name",
                            controller: nameController,
                            placeholder: "New TV",
                            enabled: !pending,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 20),
                          ThemedInputField(
                            label: "Value",
                            controller: valueController,
                            placeholder: "500",
                            enabled: !pending,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisSize: MainAxisSize.max,
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
                          BlocBuilder<BudgetCubit, dynamic>(
                              builder: (context, state) {
                            if (state != null) {
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
                                          color: addToBudget
                                              ? darkTheme.primary
                                              : darkTheme.surfaceContainer,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: addToBudget
                                          ? Icon(Icons.check)
                                          : null,
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
                        if (balanceIndex != -1) {
                          balances[balanceIndex]["value"] -=
                              double.parse(valueController.text);

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({"balances": balances});
                        }

                        if (context.mounted &&
                            context.read<BudgetCubit>().state != null &&
                            addToBudget) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update(
                            {
                              "budget": {
                                "spent":
                                    context.read<BudgetCubit>().state["spent"] +
                                        double.parse(valueController.text),
                                "value":
                                    context.read<BudgetCubit>().state["value"]
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
                            "name": nameController.text,
                            "value": double.parse(valueController.text),
                            "date": dateTime,
                            "category": selectedCategory,
                            "source": balanceIndex != -1
                                ? balances[balanceIndex]["name"]
                                : null
                          },
                        );

                        nameController.clear();
                        valueController.clear();

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
