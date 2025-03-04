import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BalancesAdd extends StatefulWidget {
  const BalancesAdd({super.key});

  @override
  State<BalancesAdd> createState() => _BalancesAddState();
}

class _BalancesAddState extends State<BalancesAdd> {
  bool pending = false;
  String error = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a new balance",
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
              text: "Add balance",
              enabled: !pending,
              onPressed: () async {
                setState(() {
                  error = "";
                  pending = true;
                });
                try {
                  if (nameController.text.isEmpty ||
                      valueController.text.isEmpty) {
                    setState(() {
                      error = "Please fill all fields";
                    });
                  } else {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .update(
                      {
                        "balances": FieldValue.arrayUnion([
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
                  setState(() {
                    error = "An error has occurred";
                  });
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
