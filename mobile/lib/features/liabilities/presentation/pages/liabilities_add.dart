import 'package:twoaxis_finance/features/liabilities/domain/entities/liability.dart';
import 'package:twoaxis_finance/features/liabilities/presentation/bloc/liabilities_bloc.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';

class LiabilitiesAdd extends StatefulWidget {
  const LiabilitiesAdd({super.key});

  @override
  State<LiabilitiesAdd> createState() => _LiabilitiesAddState();
}

class _LiabilitiesAddState extends State<LiabilitiesAdd> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LiabilitiesBloc, LiabilitiesState>(
      listener: (context, state) {
        if (state is LiabilitiesActionPending) {
          setState(() {
            pending = true;
          });
        } else if (state is LiabilitiesActionSuccess) {
          setState(() {
            pending = false;
          });
          Navigator.of(context).pop();
        } else if (state is LiabilitiesActionFailure) {
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
                                      "Add a liability.",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "Adding a liability lets you keep track of money you owe, and pay parts of it.",
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
                          const SizedBox(height: 40),
                          ThemedInputField(
                            label: "Name",
                            controller: nameController,
                            placeholder: "Mortgage",
                            enabled: !pending,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 20),
                          ThemedInputField(
                            label: "Value",
                            controller: valueController,
                            placeholder: "30000",
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
                  text: "Add liability",
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
                      
                      context.read<LiabilitiesBloc>().add(
                            AddLiabilityEvent(
                              Liability(
                                name: nameController.text,
                                value: value,
                              ),
                            ),
                          );
                      
                      context.read<TransactionsBloc>().add(
                        AddTransactionEvent(
                          name: "Added Liability: ${nameController.text}",
                          type: TransactionType.expense,
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
