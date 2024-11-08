import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiabilitiesPage extends StatefulWidget {
  const LiabilitiesPage({super.key});

  @override
  State<LiabilitiesPage> createState() => _LiabilitiesPageState();
}

class _LiabilitiesPageState extends State<LiabilitiesPage> {
  List<dynamic> liabilities = [];
  bool error = false;

  bool pending = false;
  String errorPayment = "";
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((e) {
      setState(() {
        liabilities = e.data()?["liabilities"];
      });
    }, onError: (e) {
      setState(() {
        error = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        error
            ? const Text("Error has occurred while fetching data.")
            : const SizedBox(height: 0),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: liabilities.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: darkTheme.surfaceContainer,
                    border: Border(
                        bottom:
                            BorderSide(color: darkTheme.surfaceDim, width: 3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(liabilities[index]["name"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                                "\$${NumberFormat('#,##0').format(liabilities[index]["value"]).toString()}",
                                style: TextStyle(
                                    color: darkTheme.surfaceTint,
                                    fontSize: 15)),
                          )),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext build) {
                                        return AlertDialog(
                                          title: const Text("How much to pay?"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (errorPayment.isNotEmpty)
                                                Text(
                                                  errorPayment,
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              TextField(
                                                  enabled: !pending,
                                                  controller: valueController,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "50000",
                                                    labelText: "Payment Value",
                                                  ))
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: pending
                                                  ? null
                                                  : () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      valueController.clear();
                                                    },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: pending
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        errorPayment = "";
                                                        pending = true;
                                                      });
                                                      try {
                                                        if (valueController
                                                            .text.isEmpty) {
                                                          setState(() {
                                                            errorPayment =
                                                                "Please fill the field";
                                                          });
                                                        } else {
                                                          final currentContext =
                                                              context;

                                                          liabilities[index]
                                                                  ["value"] -=
                                                              int.parse(
                                                                  valueController
                                                                      .text);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid)
                                                              .update({
                                                            "liabilities":
                                                                liabilities
                                                          });

                                                          valueController
                                                              .clear();

                                                          Navigator.of(
                                                                  currentContext)
                                                              .pop();
                                                        }
                                                      } on Exception {
                                                        setState(() {
                                                          errorPayment =
                                                              "An error has occurred";
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
                                icon: const Icon(Icons.payments)),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext build) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Are you sure to delete this liability?"),
                                          icon: const Icon(Icons.delete),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();

                                                // TODO: Error handling.
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser?.uid)
                                                    .update({
                                                  "liabilities":
                                                      FieldValue.arrayRemove(
                                                          [liabilities[index]])
                                                });
                                              },
                                              child: const Text("Yes"),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
