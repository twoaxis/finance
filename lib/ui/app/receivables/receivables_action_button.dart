import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReceivablesActionButton extends StatefulWidget {
  const ReceivablesActionButton({super.key});

  @override
  State<ReceivablesActionButton> createState() =>
      _ReceivablesActionButtonState();
}

class _ReceivablesActionButtonState extends State<ReceivablesActionButton> {
  bool pending = false;
  String error = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext build) {
                return AlertDialog(
                  title: const Text("Add a new receivable"),
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
                            hintText: "Friend's Loan",
                            labelText: "Name",
                          )),
                      TextField(
                          enabled: !pending,
                          controller: valueController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "1000000",
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
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .update({
                                    "receivables": FieldValue.arrayUnion([
                                      {
                                        "name": nameController.text,
                                        "value": int.parse(valueController.text)
                                      }
                                    ])
                                  });

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
                      child: const Text("Add"),
                    ),
                  ],
                );
              });
        },
        icon: const Icon(Icons.add));
  }
}
