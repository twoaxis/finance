import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../util/theme.dart';

class FixedExpensesScreen extends StatefulWidget {
  const FixedExpensesScreen({super.key, required this.expenses});

  final List<dynamic> expenses;

  @override
  State<FixedExpensesScreen> createState() => _FixedExpensesScreenState();
}

class _FixedExpensesScreenState extends State<FixedExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: widget.expenses.length,
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
                        child: Text(widget.expenses[index]["name"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                decoration: widget.expenses[index]['paid']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: darkTheme.primary,
                                decorationThickness: 3)),
                      ),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "\$${NumberFormat('#,##0').format(widget.expenses[index]["value"]).toString()}",
                              style: TextStyle(
                                  color: darkTheme.surfaceTint,
                                  fontSize: 20,
                                  decoration: widget.expenses[index]['paid']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: darkTheme.onPrimary,
                                  decorationThickness: 3),
                            ),
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
                                        title: Text(
                                            "Are you sure to you want to mark this expense as ${widget.expenses[index]['paid'] ? "unpaid" : "paid"}?"),
                                        icon: const Icon(Icons.payment),
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

                                              widget.expenses[index]['paid'] = !widget.expenses[index]['paid'];

                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(FirebaseAuth.instance
                                                  .currentUser?.uid)
                                                  .update({
                                                "fixedExpenses":
                                                widget.expenses
                                              });
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      );
                                    });

                              },
                              icon: const Icon(Icons.payment),
                              
                            ),
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
                                              onPressed: () async {
                                                Navigator.of(context).pop();

                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser?.uid)
                                                    .update({
                                                  "fixedExpenses":
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
                ),
              );
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
                  "\$${NumberFormat('#,##0').format(widget.expenses.fold(0, (sum, expense) => expense['paid'] ? sum + expense['value'] as int : sum))}",
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
