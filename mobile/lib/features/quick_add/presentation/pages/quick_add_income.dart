import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/app/theme.dart';
import 'package:twoaxis_finance/core/values/categories.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/balances/presentation/bloc/balances_bloc.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';

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
      initialTime: TimeOfDay.fromDateTime(dateTime),
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
        child: BlocBuilder<UserCubit, UserState>(
            builder: (BuildContext context, UserState state) {
          if (state is! UserStateAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          var user = state.user;
          var balances = user.balances;
          var menuEntries = balances.asMap().entries.map((entry) {
            return DropdownMenuEntry(
                value: entry.key, label: entry.value.name);
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
                                    const Text(
                                      "Add a one-time income.",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
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
                          const SizedBox(height: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Category:",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: 8,
                                  children:
                                      incomeCategoryIcons.keys.map((category) {
                                    var isSelected =
                                        selectedCategory == category;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = category;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
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
                                              incomeCategoryIcons[category],
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
                          const SizedBox(height: 20),
                          ThemedInputField(
                            label: "Name",
                            controller: nameController,
                            placeholder: "Birthday Gift",
                            enabled: !pending,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 20),
                          ThemedInputField(
                            label: "Value",
                            controller: valueController,
                            placeholder: "200",
                            enabled: !pending,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Add to balance:",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 5),
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
                                    const DropdownMenuEntry(
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
                          const SizedBox(height: 20),
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
                              title: const Text("Error"),
                              content: const Text("Please fill all fields"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Okay"),
                                )
                              ],
                            );
                          },
                        );
                      } else if (double.tryParse(valueController.text) == null ||
                          double.parse(valueController.text) < 0) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Please enter a valid positive value."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Okay"),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        var incomeAmount = double.parse(valueController.text);
                        if (balanceIndex != -1) {
                          var selectedBalance = balances[balanceIndex];
                          var newBalances = List<Balance>.from(balances);
                          newBalances[balanceIndex] = Balance(
                            name: selectedBalance.name,
                            value: selectedBalance.value + incomeAmount,
                          );
                          context.read<BalancesBloc>().add(UpdateBalancesListEvent(newBalances));
                        }

                        context.read<TransactionsBloc>().add(AddTransactionEvent(
                          name: nameController.text,
                          type: TransactionType.income,
                          amount: incomeAmount,
                          date: dateTime,
                          category: selectedCategory,
                          source: balanceIndex != -1
                              ? balances[balanceIndex].name
                              : null,
                        ));

                        nameController.clear();
                        valueController.clear();

                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      }
                    } on Exception {
                      if (context.mounted) {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text("An unknown error has occurred"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Okay"),
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
