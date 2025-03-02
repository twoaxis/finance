import 'package:financial_planner_mobile/cubit/liabilities_cubit.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LiabilitiesPage extends StatefulWidget {
  const LiabilitiesPage({super.key});

  @override
  State<LiabilitiesPage> createState() => _LiabilitiesPageState();
}

class _LiabilitiesPageState extends State<LiabilitiesPage> {
  bool pending = false;
  String errorPayment = "";
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: BlocBuilder<LiabilitiesCubit, List<dynamic>>(
              builder: (context, liabilities) {
            LiabilitiesCubit cubit = context.read<LiabilitiesCubit>();
            return ListView.separated(
              itemCount: liabilities.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(liabilities[index]["name"],
                            style: const TextStyle(fontSize: 15)),
                      ),
                      Text(
                          "\$${NumberFormat('#,##0').format(liabilities[index]["value"]).toString()}",
                          style: TextStyle(
                              color: darkTheme.surfaceTint, fontSize: 15)),
                      const SizedBox(width: 10),
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
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
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
                                                Navigator.of(context).pop();

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
                                                    liabilities[index]
                                                            ["value"] -=
                                                        int.parse(
                                                            valueController
                                                                .text);

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "liabilities": liabilities
                                                    });

                                                    valueController.clear();

                                                    if (context.mounted) {
                                                      Navigator.of(context)
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
                                TextEditingController nameController =
                                    TextEditingController();
                                TextEditingController valueController =
                                    TextEditingController();
                                return AlertDialog(
                                  title: const Text("Edit liability"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText: liabilities[index]["name"],
                                        ),
                                      ),
                                      TextField(
                                        controller: valueController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: liabilities[index]["value"]
                                              .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        String name =
                                            nameController.text.isEmpty
                                                ? liabilities[index]["name"]
                                                : nameController.text;
                                        int value = valueController.text.isEmpty
                                            ? liabilities[index]["value"]
                                            : int.parse(valueController.text);

                                        await cubit.editLiability(
                                          index,
                                          name: name,
                                          value: value,
                                        );
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text("Save"),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.edit),
                      ),
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
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .update({
                                          "liabilities": FieldValue.arrayRemove(
                                              [liabilities[index]])
                                        });
                                      },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.delete),
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
