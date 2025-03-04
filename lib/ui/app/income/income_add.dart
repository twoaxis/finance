import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common/primary_button.dart';

class IncomeAddItem extends StatefulWidget {
  const IncomeAddItem({super.key});

  @override
  State<IncomeAddItem> createState() => _IncomeAddItemState();
}

class _IncomeAddItemState extends State<IncomeAddItem> {
  bool pending = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a new income source",
        ),
      ),
      body: Padding(
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
                      TextField(
                        enabled: !pending,
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Job",
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: darkTheme.surfaceBright),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        enabled: !pending,
                        controller: valueController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "200",
                          labelText: "Value",
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: darkTheme.surfaceBright),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PrimaryButton(
              text: "Add income source",
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
                  } else {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .update(
                      {
                        "income": FieldValue.arrayUnion([
                          {
                            "name": nameController.text,
                            "value": int.parse(valueController.text)
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
    );
  }
}
