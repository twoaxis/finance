import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/core/widgets/themed_input_field.dart';
import 'package:financial_planner_mobile/core/theme/theme.dart';
import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/balances_cubit.dart';
import '../../core/widgets/primary_button.dart';

class QuickAddIncome extends StatefulWidget {
  const QuickAddIncome({super.key});

  @override
  State<QuickAddIncome> createState() => _QuickAddIncomeState();
}

class _QuickAddIncomeState extends State<QuickAddIncome> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int balanceIndex = -1;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    final String date =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

    int hour = dateTime.hour;
    final int minute = dateTime.minute;
    final String period = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    if (hour == 0) hour = 12;

    final String time =
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

    final DateTime fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final String formattedDate =
        "${fullDateTime.day.toString().padLeft(2, '0')}/${fullDateTime.month.toString().padLeft(2, '0')}/${fullDateTime.year}";
    final int hour =
        pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
    final String period = pickedTime.period == DayPeriod.am ? "AM" : "PM";
    final String formattedTime =
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
                                      "Add a one-time income.",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Automatically record the transaction & optionally add to your balance.",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/income.png',
                                width: 100,
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          ThemedInputField(
                            label: "Name",
                            controller: nameController,
                            placeholder: "Birthday Gift",
                            enabled: !pending,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 20),
                          ThemedInputField(
                            label: "Value",
                            controller: valueController,
                            placeholder: "200",
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
                                "Add to balance:",
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
                                        value: -1, label: "Do not add"),
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
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  text: "Add income",
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
                          balances[balanceIndex]["value"] +=
                              double.parse(valueController.text);

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
                            "type": "income",
                            "name": nameController.text,
                            "value": double.parse(valueController.text),
                            "date": dateTime,
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
