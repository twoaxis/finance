import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/liabilities/domain/entities/liability.dart';
import 'package:twoaxis_finance/features/liabilities/presentation/bloc/liabilities_bloc.dart';
import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/balances/presentation/bloc/balances_bloc.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';

class LiabilityPayment extends StatefulWidget {
  const LiabilityPayment({super.key, required this.liability, required this.liabilityIndex});

  final Liability liability;
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
        title: Text(widget.liability.name),
      ),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
            builder: (BuildContext context, UserState state) {
          if (state is! UserStateAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          var user = state.user;
          var balances = user.balances;
          var liabilities = user.liabilities;

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
                                color: Theme.of(context).colorScheme.primary,
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
                                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
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
                  onPressed: () {
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
                      } else if (double.tryParse(valueController.text) == null ||
                          double.parse(valueController.text) < 0) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Please enter a valid positive value."),
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
                        var paymentAmount = double.parse(valueController.text);
                        
                        var newLiabilities = List<Liability>.from(liabilities);
                        newLiabilities[widget.liabilityIndex] = Liability(
                          name: widget.liability.name,
                          value: widget.liability.value - paymentAmount,
                        );
                        context.read<LiabilitiesBloc>().add(UpdateLiabilitiesListEvent(newLiabilities));

                        if(balanceIndex != -1) {
                          var selectedBalance = balances[balanceIndex];
                          var newBalances = List<Balance>.from(balances);
                          newBalances[balanceIndex] = Balance(
                            name: selectedBalance.name,
                            value: selectedBalance.value - paymentAmount,
                          );
                          context.read<BalancesBloc>().add(UpdateBalancesListEvent(newBalances));
                        }

                        context.read<TransactionsBloc>().add(AddTransactionEvent(
                          name: widget.liability.name,
                          type: TransactionType.expense,
                          amount: paymentAmount,
                          source: balanceIndex != -1 ? balances[balanceIndex].name : null,
                        ));
                        
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      }

                    } on Exception {
                      if (context.mounted) {
                        showDialog(
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
