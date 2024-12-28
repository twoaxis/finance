import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpensesActionButtonOptions extends StatelessWidget {
  const ExpensesActionButtonOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsetsDirectional.only(top: 20),
                height: 200,
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text("Reset one-time expenses"),
                      onTap: () {

                        Navigator.pop(context);
                        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
                          "expenses": []
                        });
                      },
                    ),
                    ListTile(
                      title: const Text("Mark all fixed-expenses as unpaid"),
                      onTap: () async {

                        Navigator.pop(context);

                        DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);
                        DocumentSnapshot docSnapshot = await docRef.get();

                        if (docSnapshot.exists) {
                          List<dynamic> fixedExpenses = docSnapshot['fixedExpenses'];

                          for (var expense in fixedExpenses) {
                            if (expense is Map) {
                              expense['paid'] = false;
                            }
                          }
                          await docRef.update({
                            'fixedExpenses': fixedExpenses,
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            });
      },
      icon: const Icon(Icons.menu),
    );
  }
}
