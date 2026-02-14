import 'package:twoaxis_finance/features/bills/domain/entities/bill.dart';
import 'package:twoaxis_finance/features/bills/presentation/bloc/bills_bloc.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/app/theme.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/widgets/primary_button.dart';

class BillsAddItem extends StatefulWidget {
  const BillsAddItem({super.key});

  @override
  State<BillsAddItem> createState() => _BillsAddItemState();
}

class _BillsAddItemState extends State<BillsAddItem> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BillsBloc, BillsState>(
      listener: (context, state) {
        if (state is BillsActionPending) {
          setState(() {
            pending = true;
          });
        } else if (state is BillsActionSuccess) {
          setState(() {
            pending = false;
          });
          Navigator.of(context).pop();
        } else if (state is BillsActionFailure) {
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
                                      "Add a recurring bill.",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "Adding a bill lets you pay it from one of your balances without manually adding an expense.",
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
                          const SizedBox(height: 40),
                          ThemedInputField(
                            label: "Name",
                            controller: nameController,
                            placeholder: "Groceries",
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
                        ],
                      ),
                    ),
                  ),
                ),
                PrimaryButton(
                  text: "Add bill",
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
                      context.read<BillsBloc>().add(
                            AddBillEvent(
                              Bill(
                                name: nameController.text,
                                value: double.parse(valueController.text),
                              ),
                            ),
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
