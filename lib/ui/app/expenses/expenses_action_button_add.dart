import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpensesActionButtonAdd extends StatefulWidget {
  const ExpensesActionButtonAdd({super.key});

  @override
  State<ExpensesActionButtonAdd> createState() => _ExpensesActionButtonAddState();
}

class _ExpensesActionButtonAddState extends State<ExpensesActionButtonAdd> {
  bool pending = false;
  String error = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  bool isFixed = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext build) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: const Text("Add a new expense"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (error.isNotEmpty)
                          Text(
                            error,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        TextField(
                            enabled: !pending,
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: "Groceries",
                              labelText: "Name",
                            )),
                        Row(
                          children: [
                            const Expanded(child: Text("Fixed?")),
                            Checkbox(
                              checkColor: Colors.white,
                              value: isFixed,
                              onChanged: (bool? value) {
                                setState(() {
                                  isFixed = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        TextField(
                            enabled: !pending,
                            controller: valueController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "200",
                              labelText: "Value",
                            ))
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: pending
                            ? null
                            : () {
                                Navigator.of(context).pop();

                                nameController.clear();
                                valueController.clear();
                              },
                        child: const Text("Cancel"),
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
                                    final currentContext = context;

                                    if (isFixed) {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .update({
                                        "fixedExpenses": FieldValue.arrayUnion([
                                          {
                                            "name": nameController.text,
                                            "value":
                                                int.parse(valueController.text),
                                            "paid": false
                                          }
                                        ])
                                      });
                                    }
                                    else {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                          .update({
                                        "expenses": FieldValue.arrayUnion([
                                          {
                                            "name": nameController.text,
                                            "value":
                                            int.parse(valueController.text),
                                          }
                                        ])
                                      });
                                    }

                                    nameController.clear();
                                    valueController.clear();
                                    setState(() {
                                      isFixed = false;
                                    });

                                    Navigator.of(context).pop();
                                  }
                                } on Exception catch (e) {
                                  setState(() {
                                    error = "An error has occurred";
                                  });
                                } finally {
                                  setState(() {
                                    pending = false;
                                  });
                                }
                              },
                        child: const Text("Add"),
                      ),
                    ],
                  );
                });
              });
        },
        icon: const Icon(Icons.add));
  }
}
