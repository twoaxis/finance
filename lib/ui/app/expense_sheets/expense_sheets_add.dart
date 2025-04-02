import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common/themed_input_field.dart';

class ExpenseSheetsAdd extends StatefulWidget {
  const ExpenseSheetsAdd({super.key});

  @override
  State<ExpenseSheetsAdd> createState() => _ExpenseSheetsAddState();
}

class _ExpenseSheetsAddState extends State<ExpenseSheetsAdd> {
  bool pending = false;

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(fullscreenSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                                    "Create an expense sheet.",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Creating an expense sheet allows you to group expenses together.",
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
                        ThemedInputField(
                          label: "Name",
                          controller: nameController,
                          placeholder: "July 2025 Expenses",
                          enabled: !pending,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                text: "Create expense sheet",
                enabled: !pending,
                onPressed: () async {
                  setState(() {
                    pending = true;
                  });

                  try {
                    if (nameController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("Please enter a name"),
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
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("expenses")
                          .add({
                        "name": nameController.text,
                        "createdAt": FieldValue.serverTimestamp(),
                        "expenses": []
                      });
                      if (context.mounted) {
                        Navigator.pop(context);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
