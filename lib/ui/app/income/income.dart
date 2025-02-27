import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: BlocBuilder<IncomeCubit, List<dynamic>>(
            builder: (context, income) {
              return ListView.separated(
                itemCount: income.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(income[index]["name"],
                              style: const TextStyle(fontSize: 15)),
                        ),
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                  "\$${NumberFormat('#,##0').format(income[index]["value"]).toString()}",
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
                                                "Are you sure to delete this income source?"),
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
                                                    "income":
                                                        FieldValue.arrayRemove(
                                                            [income[index]])
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
            },
          ),
        ),
      ],
    );
  }
}
