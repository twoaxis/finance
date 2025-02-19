import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  List<dynamic> assets = [];
  bool error = false;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((e) {
      if (mounted) {
        setState(() {
          assets = e.data()?["assets"];
        });
      }
    }, onError: (e) {
      if (mounted) {
        setState(() {
          error = true;
        });
      }
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
          child: ListView.separated(
            itemCount: assets.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(assets[index]["name"],
                          style: const TextStyle(fontSize: 15)),
                    ),
                    Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                              "\$${NumberFormat('#,##0').format(assets[index]["value"]).toString()}",
                              style: TextStyle(
                                  color: darkTheme.surfaceTint, fontSize: 15)),
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
                                            "Are you sure to delete this asset?"),
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
                                                "assets":
                                                    FieldValue.arrayRemove(
                                                        [assets[index]])
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
      ],
    );
  }
}
