import 'package:financial_planner_mobile/cubit/assets_cubit.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: BlocBuilder<AssetsCubit, List<dynamic>>(
              builder: (context, assets) {
            AssetsCubit cubit = context.read<AssetsCubit>();
            return ListView.separated(
              itemCount: assets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(assets[index]["name"],
                            style: const TextStyle(fontSize: 15)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                          "\$${NumberFormat('#,##0').format(assets[index]["value"]).toString()}",
                          style: TextStyle(
                              color: darkTheme.surfaceTint, fontSize: 15)),
                      const SizedBox(width: 10),
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
                                  title: const Text("Edit asset"),
                                  icon: const Icon(Icons.edit),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText: assets[index]["name"],
                                        ),
                                      ),
                                      TextField(
                                        controller: valueController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText:
                                              assets[index]["value"].toString(),
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
                                                ? assets[index]["name"]
                                                : nameController.text;
                                        int value = valueController.text.isEmpty
                                            ? assets[index]["value"]
                                            : int.parse(valueController.text);
                                        await cubit.editAsset(
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
                        icon: Icon(Icons.edit),
                      ),
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
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid)
                                              .update({
                                            "assets": FieldValue.arrayRemove(
                                                [assets[index]])
                                          });
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete))
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
