import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncomeActionButton extends StatefulWidget {
  const IncomeActionButton({super.key});

  @override
  State<IncomeActionButton> createState() => _IncomeActionButtonState();
}

class _IncomeActionButtonState extends State<IncomeActionButton> {
  bool pending = false;
  String error = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  late BuildContext currentContext;

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentContext = context;
    });
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext build) {
                return AlertDialog(
                  title: const Text("Add a new income source"),
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
                            hintText: "Job",
                            labelText: "Name",
                          )),
                      TextField(
                          enabled: !pending,
                          controller: valueController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "20000",
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

                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .update({
                                    "income": FieldValue.arrayUnion([
                                      {
                                        "name": nameController.text,
                                        "value": int.parse(valueController.text)
                                      }
                                    ])
                                  });

                                  nameController.clear();
                                  valueController.clear();

                                  Navigator.of(currentContext).pop();
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
        },
        icon: const Icon(Icons.add));
  }
}
