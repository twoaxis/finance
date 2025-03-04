import 'package:financial_planner_mobile/ui/common/primary_button.dart';
import 'package:financial_planner_mobile/ui/onboarding/screens/email_verify.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
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
                      ],
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                  text: "Reset Password",
                  enabled: !pending,
                  onPressed: () async {
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
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: emailController.text,
                        );

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmailVerify(),
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
                              content: Text("An unexpected error has occurred"),
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
                  }),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
