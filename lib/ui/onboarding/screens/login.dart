import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:financial_planner_mobile/ui/common/themed_input_field.dart';
import 'package:financial_planner_mobile/ui/onboarding/screens/forget_password.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
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
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset("asset/images/logo.png"),
                          Text(
                            "Get back to your money!",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Login to your account",
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
                            textInputAction: TextInputAction.done,
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
                  PrimaryButton(
                    text: "Login to your account",
                    enabled: !pending,
                    onPressed: () async {
                      {
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
