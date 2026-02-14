import 'package:twoaxis_finance/app/theme.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/bills/domain/entities/bill.dart';
import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/balances/presentation/bloc/balances_bloc.dart';
import 'package:twoaxis_finance/features/budget/domain/entities/budget.dart';
import 'package:twoaxis_finance/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';

class BillPayment extends StatefulWidget {
  const BillPayment({super.key, required this.bill, required this.index});

  final Bill bill;
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
        title: Text(widget.bill.name),
      ),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
            builder: (BuildContext context, UserState state) {
          if (state is! UserStateAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          var user = state.user;
          var balances = user.balances;
          var budget = user.budget;

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
                          if (budget != null)
                            GestureDetector(
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
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  text: "Pay bill",
                  enabled: !pending,
                  onPressed: () {
                    setState(() {
                      pending = true;
                    });
                    try {
                        if(balanceIndex != -1) {
                          var selectedBalance = balances[balanceIndex];
                          var newBalances = List<Balance>.from(balances);
                          newBalances[balanceIndex] = Balance(
                            name: selectedBalance.name,
                            value: selectedBalance.value - widget.bill.value,
                          );
                          context.read<BalancesBloc>().add(UpdateBalancesListEvent(newBalances));
                        }

                        if(budget != null && addToBudget) {
                          var newBudget = Budget(
                            spent: budget.spent + widget.bill.value,
                            value: budget.value,
                          );
                          context.read<BudgetBloc>().add(UpdateBudgetEvent(newBudget));
                        }

                        context.read<TransactionsBloc>().add(AddTransactionEvent(
                          name: widget.bill.name,
                          type: TransactionType.expense,
                          amount: widget.bill.value,
                          source: balanceIndex != -1 ? balances[balanceIndex].name : null,
                        ));

                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
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
