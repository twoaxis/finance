import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common/primary_button.dart';
import '../../common/themed_input_field.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a new receivable",
        ),
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
                        Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add an receivable.",
                                    style: TextStyle(
                                        fontSize: 25, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Adding a receivable allows you to track money owed to you and automatically add it to one of your balances!",
                                    style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
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
                        SizedBox(height: 40),
                        ThemedInputField(
                          label: "Name",
                          controller: nameController,
                          placeholder: "Lent Money",
                          enabled: !pending,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20),
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
                            content:
                            Text("Please fill all fields"),
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
                    } else if(double.parse(valueController.text) < 0) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content:
                            Text("Value cannot be negative."),
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
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update(
                        {
                          "receivables": FieldValue.arrayUnion([
                            {
                              "name": nameController.text,
                              "value": double.parse(valueController.text)
                            }
                          ])
                        },
                      );
                      nameController.clear();
                      valueController.clear();
        
                      if (context.mounted) {
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
                            content:
                            Text("Value must be an number."),
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
                            content:
                            Text("An unknown error has occurred"),
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
