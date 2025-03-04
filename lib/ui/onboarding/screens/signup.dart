import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool pending = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create an account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(fullscreenSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        enabled: !pending,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "john@hotmail.com",
                          labelText: "E-mail",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.surfaceBright),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        enabled: !pending,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "••••••••••••",
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.surfaceBright),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: repeatPasswordController,
                        obscureText: true,
                        enabled: !pending,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "••••••••••••",
                          labelText: "Repeat Password",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.surfaceBright),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            PrimaryButton(
                text: "Create your account",
                enabled: !pending,
                onPressed: () async {
                  setState(() {
                    pending = true;
                  });
                  try {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        repeatPasswordController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("Please fill all fields"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Okay"),
                              )
                            ],
                          );
                        },
                      );
                    } else if (passwordController.text !=
                        repeatPasswordController.text) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("Passwords don't match"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Okay"),
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(credential.user!.uid)
                          .set({
                        "assets": [],
                        "expenses": [],
                        "income": [],
                        "liabilities": [],
                        "fixedExpenses": [],
                        "receivables": []
                      });

                      await credential.user?.sendEmailVerification();

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Password is too weak"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Okay"),
                                )
                              ],
                            );
                          },
                        );
                      }
                    } else if (e.code == 'email-already-in-use') {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("E-mail already exists"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Okay"),
                                )
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("An unknown error has occurred"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Okay"),
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        pending = false;
                      });
                    }
                  }
                }),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
