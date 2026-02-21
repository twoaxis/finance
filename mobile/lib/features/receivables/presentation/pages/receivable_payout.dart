import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/receivables/domain/entities/receivable.dart';
import 'package:twoaxis_finance/features/receivables/presentation/bloc/receivables_bloc.dart';
import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/balances/presentation/bloc/balances_bloc.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';

class ReceivablePay extends StatefulWidget {
  const ReceivablePay({super.key, required this.receivable, required this.index});

  final int index;
  final Receivable receivable;

  @override
  State<ReceivablePay> createState() => _ReceivablePayState();
}

class _ReceivablePayState extends State<ReceivablePay> {
  bool pending = false;

  TextEditingController valueController = TextEditingController();
  int balanceIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receivable.name),
      ),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
            builder: (BuildContext context, UserState state) {
          if (state is! UserStateAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          var user = state.user;
          var balances = user.balances;
          var receivables = user.receivables;

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
                                      "Receivable payment",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "Mark some or all of this receivable as paid.",
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
                          ThemedInputField(
                            label: "How much was paid?",
                            controller: valueController,
                            placeholder: "2000",
                            enabled: !pending,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 30),
                          Column(
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
                                    const DropdownMenuEntry(
                                        value: -1,
                                        label: "Do not add"),
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
                  text: "Pay receivable",
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
                              title: const Text("Error"),
                              content: const Text("Please input a value."),
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
                          double.parse(valueController.text) > widget.receivable.value) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: Text("Value has to be a valid number less than or equal to ${widget.receivable.value}."),
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
                        var paidAmount = double.parse(valueController.text);

                        if (paidAmount == widget.receivable.value) {
                          context.read<ReceivablesBloc>().add(RemoveReceivableEvent(widget.receivable));
                        }
                        else {
                          var newReceivables = List<Receivable>.from(receivables);
                          newReceivables[widget.index] = Receivable(
                            name: widget.receivable.name,
                            value: widget.receivable.value - paidAmount,
                          );
                          context.read<ReceivablesBloc>().add(UpdateReceivablesListEvent(newReceivables));
                        }

                        if (balanceIndex != -1) {
                          var selectedBalance = balances[balanceIndex];
                          var newBalances = List<Balance>.from(balances);
                          newBalances[balanceIndex] = Balance(
                            name: selectedBalance.name,
                            value: selectedBalance.value + paidAmount,
                          );
                          context.read<BalancesBloc>().add(UpdateBalancesListEvent(newBalances));
                        }

                        context.read<TransactionsBloc>().add(AddTransactionEvent(
                          name: widget.receivable.name,
                          type: TransactionType.income,
                          amount: paidAmount,
                          source: balanceIndex != -1
                              ? balances[balanceIndex].name
                              : null
                        ));

                        valueController.clear();

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
