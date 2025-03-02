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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login to your account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
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
                                borderSide: BorderSide(
                                    color: darkTheme.surfaceBright))),
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
                                borderSide: BorderSide(
                                    color: darkTheme.surfaceBright))),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPassword(),
                            ),
                          );
                        },
                        child: Text("Forgot password?"),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  elevation: 3,
                ),
                onPressed: pending
                    ? null
                    : () async {
                        setState(() {
                          pending = true;
                        });

                        try {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
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
                          } else {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email' ||
                              e.code == 'invalid-credential' ||
                              e.code == 'user-not-found' ||
                              e.code == 'wrong-password') {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text("Invalid E-mail or Password"),
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
                          } else if (e.code == "email-already-in-use") {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text("Invalid E-mail or Password"),
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
                          setState(() {
                            pending = false;
                          });
                        }
                      },
                child: Text(
                  "Login to your account",
                  style: TextStyle(color: darkTheme.onPrimary),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
