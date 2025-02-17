import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool pending = false;
  String error = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create an account",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            error.isNotEmpty
                ? Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  )
                : const SizedBox(
                    height: 20,
                  ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.7, // Set width to 90% of screen size
              child: TextField(
                controller: emailController,
                enabled: !pending,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: "john@hotmail.com",
                  labelText: "E-mail",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.7, // Set width to 90% of screen size
              child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  enabled: !pending,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    hintText: "⦁⦁⦁⦁⦁⦁⦁⦁⦁⦁⦁",
                    labelText: "Password",
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.7, // Set width to 90% of screen size
              child: TextField(
                  controller: repeatPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: !pending,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    hintText: "⦁⦁⦁⦁⦁⦁⦁⦁⦁⦁⦁",
                    labelText: "Repeat Password",
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: darkTheme.primary,
                  foregroundColor: darkTheme.onPrimary),
              onPressed: pending
                  ? null
                  : () async {
                      setState(() {
                        pending = true;
                        error = "";
                      });

                      try {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            repeatPasswordController.text.isEmpty) {
                          setState(() {
                            error = "Please fill all fields";
                          });
                        } else if (passwordController.text !=
                            repeatPasswordController.text) {
                          setState(() {
                            error = "The passwords don't match";
                          });
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
                          });

                          await credential.user?.sendEmailVerification();

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          setState(() {
                            error = "Your password is too weak";
                          });
                        } else if (e.code == 'email-already-in-use') {
                          setState(() {
                            error = "E-mail is already in use";
                          });
                        }
                      } finally {
                        setState(() {
                          pending = false;
                        });
                      }
                    },
              child: const Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
