import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/ui/common/themed_input_field.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/primary_button.dart';
import 'income_details.dart';

class IncomeEditItem extends StatefulWidget {
  const IncomeEditItem({super.key, required this.index, required this.income});

  final int index;
  final Map income;

  @override
  State<IncomeEditItem> createState() => _IncomeEditItemState();
}

class _IncomeEditItemState extends State<IncomeEditItem> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.income["name"];
    valueController.text = widget.income["value"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        SizedBox(height: 40),
                        ThemedInputField(
                            label: "Name",
                            controller: nameController,
                            placeholder: "Job",
                          enabled: !pending,
                            textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20),
                        ThemedInputField(
                          label: "Value",
                          controller: valueController,
                          placeholder: "2000",
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
                text: "Update income source",
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


                      context
                          .read<IncomeCubit>().state[widget.index]["name"] = nameController.text;
                      context
                          .read<IncomeCubit>().state[widget.index]["value"] = double.parse(valueController.text);

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update(
                        {
                          "income": context.read<IncomeCubit>().state
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
        ),
      ),
    );
  }
}
