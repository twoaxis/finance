import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/ui/app/expense_sheets/expense_sheet_items_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../util/theme.dart';

class ExpenseSheetItems extends StatefulWidget {
  const ExpenseSheetItems({
    super.key,
    required this.sheetIndex,
  });

  final int sheetIndex;

  @override
  State<ExpenseSheetItems> createState() => _ExpenseSheetItemsState();
}

class _ExpenseSheetItemsState extends State<ExpenseSheetItems> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesCubit, List<dynamic>>(
        builder: (context, sheets) {
      return Scaffold(
        appBar: AppBar(
          title: Text(sheets[widget.sheetIndex]["name"]),
          actions: [
            ExpenseSheetItemsActionButton(sheet: sheets[widget.sheetIndex])
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: sheets[widget.sheetIndex]["expenses"].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sheets[widget.sheetIndex]["expenses"][index]["name"],
                                  style: const TextStyle(
                                    fontSize: 15,
                                  )),
                              Text(
                                  sheets[widget.sheetIndex]["expenses"][index]["date"]
                                      .toDate()
                                      .toString()
                                      .split(" ")[0]
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 13, color: darkTheme.primary)),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                  "\$${NumberFormat('#,##0').format(sheets[widget.sheetIndex]["expenses"][index]["value"]).toString()}",
                                  style: TextStyle(
                                      color: darkTheme.primary, fontSize: 15)),
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
                                                      .collection("expenses")
                                                      .doc(sheets[widget.sheetIndex].id)
                                                      .update({
                                                    "expenses":
                                                        FieldValue.arrayRemove([
                                                      sheets[widget.sheetIndex]["expenses"]
                                                          [index]
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                      //"test",
                      "\$${NumberFormat('#,##0').format(sheets[widget.sheetIndex].get("expenses").fold(0, (total, expense) => total + expense['value'] as int))}",
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
        ),
      );
    });
  }
}
