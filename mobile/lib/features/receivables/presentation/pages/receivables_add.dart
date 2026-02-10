import 'package:twoaxis_finance/features/receivables/domain/entities/receivable.dart';
import 'package:twoaxis_finance/features/receivables/presentation/bloc/receivables_bloc.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';

class AddReceivables extends StatefulWidget {
  const AddReceivables({super.key});

  @override
  State<AddReceivables> createState() => _AddReceivablesState();
}

class _AddReceivablesState extends State<AddReceivables> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReceivablesBloc, ReceivablesState>(
      listener: (context, state) {
        if (state is ReceivablesActionPending) {
          setState(() {
            pending = true;
          });
        } else if (state is ReceivablesActionSuccess) {
          setState(() {
            pending = false;
          });
          Navigator.of(context).pop();
        } else if (state is ReceivablesActionFailure) {
          setState(() {
            pending = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(fullscreenSpacing),
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
                                      "Add an receivable.",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "Adding a receivable allows you to track money owed to you and automatically add it to one of your balances!",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/receivables.png',
                                width: 100,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          ThemedInputField(
                            label: "Name",
                            controller: nameController,
                            placeholder: "Lent Money",
                            enabled: !pending,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 20),
                          ThemedInputField(
                            label: "Value",
                            controller: valueController,
                            placeholder: "100",
                            enabled: !pending,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  text: "Add receivable",
                  enabled: !pending,
                  onPressed: () {
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
                      var value = double.parse(valueController.text);
                      
                      context.read<ReceivablesBloc>().add(
                            AddReceivableEvent(
                              Receivable(
                                name: nameController.text,
                                value: value,
                              ),
                            ),
                          );
                      
                      context.read<TransactionsBloc>().add(
                        AddTransactionEvent(
                          name: "New Receivable: ${nameController.text}",
                          type: TransactionType.income,
                          amount: value,
                        )
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
