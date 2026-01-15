import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:financial_planner_mobile/ui/common/themed_input_field.dart';

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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context)
                .size
                .height, // Extends beyond the App Bar
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [darkTheme.secondary, Colors.transparent],
                radius: 1,
                center: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(fullscreenSpacing),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                      )
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset("assets/images/logo.png"),
                            Text(
                              "The next step to riches!",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Create your account now!",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(height: 40),
                            ThemedInputField(
                              label: "E-mail",
                              controller: emailController,
                              placeholder: "john@hotmail.com",
                              enabled: !pending,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 20),
                            ThemedInputField(
                              label: "Password",
                              controller: passwordController,
                              placeholder: "•••••••••••",
                              enabled: !pending,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 20),
                            ThemedInputField(
                              label: "Repeat Password",
                              controller: repeatPasswordController,
                              placeholder: "•••••••••••",
                              enabled: !pending,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                            ),
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
                          var credential = await FirebaseAuth.instance
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
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
