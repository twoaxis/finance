import 'package:twoaxis_finance/cubit/balances_cubit.dart';
import 'package:twoaxis_finance/ui/app/balances/balances_action_button.dart';
import 'package:twoaxis_finance/core/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/util/money_format.dart';

class BalancesPage extends StatefulWidget {
  const BalancesPage({super.key});

  @override
  State<BalancesPage> createState() => _BalancesPageState();
}

class _BalancesPageState extends State<BalancesPage> {
  bool pending = false;
  String errorPayment = "";
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balances"),
        backgroundColor: darkTheme.surfaceContainer,
        actions: [BalancesActionButton()],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: BlocBuilder<BalancesCubit, List<dynamic>>(
                builder: (context, balances) {
              if (balances.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "assets/images/empty_data.png",
                          width: 200,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Opacity(
                        opacity: 0.3,
                        child: Text(
                          "No balances added",
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    ],
                  ),
                );
              }
              return ListView.separated(
                itemCount: balances.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(balances[index]["name"],
                              style: const TextStyle(fontSize: 15)),
                        ),
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                  formatMoneyWithContext(context, balances[index]["value"]),
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
                                    valueController.text =
                                        balances[index]["value"].toString();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext build) {
                                          return AlertDialog(
                                            title: const Text("Edit Balance"),
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
                                                      labelText:
                                                          "Payment Value",
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
                                                            balances[index]
                                                                    ["value"] =
                                                                double.parse(
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
                                                              "balances":
                                                                  balances
                                                            });

                                                            valueController
                                                                .clear();

                                                            if (context
                                                                .mounted) {
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
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext build) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Are you sure to delete this balance?"),
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
                                                  "balances":
                                                      FieldValue.arrayRemove(
                                                          [balances[index]])
                                                });
                                              },
                                              child: const Text("Yes"),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.delete),
                              ),
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
      ),
    );
  }
}
