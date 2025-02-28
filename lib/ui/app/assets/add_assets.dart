import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAssets extends StatefulWidget {
  const AddAssets({super.key});

  @override
  State<AddAssets> createState() => _AddAssetsState();
}

class _AddAssetsState extends State<AddAssets> {
  bool pending = false;
  String error = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a new asset",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 35.0, left: 35.0, top: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                hintText: "My beautiful car",
                labelText: "Name",
              ),
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
                                  "assets": FieldValue.arrayUnion(
                                    [
                                      {
                                        "name": nameController.text,
                                        "value": int.parse(valueController.text)
                                      }
                                    ],
                                  ),
                                },
                              );
                              nameController.clear();
                              valueController.clear();

                              if (context.mounted) Navigator.of(context).pop();
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
