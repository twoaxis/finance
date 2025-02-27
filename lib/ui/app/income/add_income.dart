import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  bool pending = false;
  String error = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: heightScreen * 0.25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add a new income source",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                children: [
                  if (error.isNotEmpty)
                    Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  TextField(
                    enabled: !pending,
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: "Job",
                      labelText: "Name",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    enabled: !pending,
                    controller: valueController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "20000",
                      labelText: "Value",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: pending
                      ? null
                      : () {
                          Navigator.of(context).pop();

                          nameController.clear();
                          valueController.clear();
                        },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: pending
                      ? null
                      : () async {
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
                            setState(() {
                              error = "An error has occurred";
                            });
                          } finally {
                            setState(() {
                              pending = false;
                            });
                          }
                        },
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
