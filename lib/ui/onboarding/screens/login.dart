import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final Function(int page) changePage;

  const LoginPage({super.key, required this.changePage});

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
    return  Column(
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
        error.isNotEmpty ?
        Text(
          error,
          style: const TextStyle(
              color: Colors.red,
              fontSize: 20
          ),
        )
            :
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7, // Set width to 90% of screen size
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
          width: MediaQuery.of(context).size.width * 0.7, // Set width to 90% of screen size
          child: TextField(
              obscureText: true,
              controller: passwordController,
              enabled: !pending,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                hintText: "⦁⦁⦁⦁⦁⦁⦁⦁⦁⦁⦁",
                labelText: "Password",
              )
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(onPressed: pending ? null : () async {

          setState(() {
            pending = true;
            error = "";
          });

          try {
            if(emailController.text.isEmpty || passwordController.text.isEmpty) {
              setState(() {
                error = "Please fill all fields";
              });
            }
            else {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              );
            }
          }
          on FirebaseAuthException catch (e) {
            if (e.code == 'invalid-email' || e.code == 'invalid-credential' || e.code == 'user-not-found' || e.code == 'wrong-password')  {
              setState(() {
                error = "Invalid E-mail or password";
              });
            }

          }
          finally {

            setState(() {
              pending = false;
            });
          }

        }, child: const Text("Login")),
        TextButton(onPressed: pending ? null : () async {
          widget.changePage(1);

        }, child: const Text("Don't have an account?"))
      ],
    );
  }
}