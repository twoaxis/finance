import 'package:financial_planner_mobile/cubit/receivables_cubit.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ReceivablesPage extends StatefulWidget {
  const ReceivablesPage({super.key});

  @override
  State<ReceivablesPage> createState() => _ReceivablesPageState();
}

class _ReceivablesPageState extends State<ReceivablesPage> {
  bool pending = false;
  String errorPayment = "";
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: BlocBuilder<ReceivablesCubit, List<dynamic>>(
              builder: (context, receivables) {
            return ListView.separated(
              itemCount: receivables.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(receivables[index]["name"],
                            style: const TextStyle(fontSize: 15)),
                      ),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                                "\$${NumberFormat('#,##0').format(receivables[index]["value"]).toString()}",
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
                                          title:
                                              const Text("How much was paid?"),
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
                                                          receivables[index]
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
                                                            "receivables":
                                                                receivables
                                                          });

                                                          valueController
                                                              .clear();

                                                          if (context.mounted) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
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
                                              "Are you sure to delete this receivable?"),
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
                                                  "receivables":
                                                      FieldValue.arrayRemove(
                                                          [receivables[index]])
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
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: darkTheme.surfaceContainer, height: 1);
              },
            );
          }),
        ),
      ],
    );
  }
}
