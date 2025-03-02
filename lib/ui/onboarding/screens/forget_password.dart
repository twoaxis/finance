import 'package:financial_planner_mobile/ui/onboarding/screens/email_verify.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    super.key,
  });

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  bool pending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Forget password"),
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
                              borderSide:
                                  BorderSide(color: darkTheme.surfaceBright),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                            if (emailController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text("Please enter your e-mail"),
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
                                  .sendPasswordResetEmail(
                                email: emailController.text,
                              );

                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailVerify(),
                                  ),
                                );
                              }
                            }
                          } on Exception {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(
                                        "An unexpected error has occurred"),
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
                          } finally {
                            setState(() {
                              pending = false;
                            });
                          }
                        },
                  child: Text(
                    "Reset password",
                    style: TextStyle(color: darkTheme.onPrimary),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
