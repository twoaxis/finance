import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../util/theme.dart';

class OneTimeExpensesScreen extends StatefulWidget {
  const OneTimeExpensesScreen({super.key, required this.expenses});

  final List<dynamic> expenses;

  @override
  State<OneTimeExpensesScreen> createState() => _OneTimeExpensesScreenState();
}

class _OneTimeExpensesScreenState extends State<OneTimeExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: widget.expenses.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(widget.expenses[index]["name"],
                          style: const TextStyle(fontSize: 15)),
                    ),
                    Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                              "\$${NumberFormat('#,##0').format(widget.expenses[index]["value"]).toString()}",
                              style: TextStyle(
                                  color: darkTheme.primary,
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
                                        title: const Text(
                                            "Are you sure to delete this expense?"),
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

                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .update({
                                                "expenses":
                                                    FieldValue.arrayRemove([
                                                  widget.expenses[index]
                                                ])
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
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: darkTheme.surfaceContainer,
              border: Border(bottom: BorderSide(color: darkTheme.surface))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Total",
                    style: TextStyle(
                        color: darkTheme.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "\$${NumberFormat('#,##0').format(widget.expenses.fold(0, (sum, expense) => sum + expense['value'] as int))}",
                  style: TextStyle(
                    color: darkTheme.onPrimary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
