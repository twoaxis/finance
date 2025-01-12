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
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Forget Password",
                style: TextStyle(
                  color: darkTheme.onPrimary,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                enabled: !pending,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: "john@hotmail.com",
                  labelText: "E-mail",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkTheme.primary,
                  foregroundColor: darkTheme.onPrimary,
                ),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailVerify(),
                      ),
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          e.toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                        content: Text(
                          'An error occurred while sending the password reset email',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Reset Password",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
