import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/ui/app/expense_sheets/expense_sheet_items.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseSheetsPage extends StatefulWidget {
  const ExpenseSheetsPage({super.key});

  @override
  State<ExpenseSheetsPage> createState() => _ExpenseSheetsPageState();
}

class _ExpenseSheetsPageState extends State<ExpenseSheetsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ExpensesCubit, List<dynamic>>(
            builder: (context, expenses) {
              return ListView.separated(
                itemCount: expenses.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(expenses[index].data()["name"]),
                    onLongPress: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext build) {
                            return AlertDialog(
                              title: Text("Are you sure?"),
                              content: Text(
                                  "Deleting \"${expenses[index].data()["name"]}\" will delete all expenses within it permanently.",),
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
                                        .currentUser?.uid).collection("expenses").doc(expenses[index].id).delete();
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpenseSheetItems(sheetIndex: index),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: darkTheme.surfaceContainer, height: 1);
                },
              );
            },
          ),
        )
      ],
    );
  }
}
