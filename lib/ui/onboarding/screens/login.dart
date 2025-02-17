import 'package:financial_planner_mobile/ui/onboarding/screens/forget_password.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool pending = false;
  String error = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              "Log into your account",
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
                            passwordController.text.isEmpty) {
                          setState(() {
                            error = "Please fill all fields";
                          });
                        } else {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          if(context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-email' ||
                            e.code == 'invalid-credential' ||
                            e.code == 'user-not-found' ||
                            e.code == 'wrong-password') {
                          setState(() {
                            error = "Invalid E-mail or password";
                          });
                        }
                      } finally {
                        setState(() {
                          pending = false;
                        });
                      }
                    },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: pending
                  ? null
                  : () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPassword(),
                        ),
                      );
                    },
              child: const Text("Forgot your password"),
            ),
          ],
        ),
      ),
    );
  }
}
