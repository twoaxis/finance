import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/features/auth/presentation/pages/login.dart';
import 'package:twoaxis_finance/features/auth/presentation/pages/signup.dart';
import 'package:twoaxis_finance/app/theme.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Image.asset("assets/images/logo.png"),
                      Text(
                        "TwoAxis Finance",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Your key to riches.",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          GoogleSignInAccount? googleUser =
                              await GoogleSignIn().signIn();

                          GoogleSignInAuthentication? googleAuth =
                              await googleUser?.authentication;

                          var credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth?.accessToken,
                            idToken: googleAuth?.idToken,
                          );

                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                        },
                        child: Image.asset(
                          "assets/images/google.png",
                          width: 70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.grey,
                      )),
                      Text(
                        "Or",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.grey,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PrimaryButton(
                      text: "Login to your account",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: darkTheme.surfaceContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          shadowColor: Colors.black,
                          elevation: 3),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                      child: Text(
                        "Create an account",
                        style: TextStyle(color: darkTheme.onPrimary),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Uri uri =
                          Uri.parse("https://finance.twoaxis.org/privacy.html");

                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "By using our app, you're subject to our ",
                        children: [
                          TextSpan(
                            text: "Privacy Policy", // Underlined part
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0x66FFFFFF),
                              decorationThickness: 2,
                            ),
                          ),
                          TextSpan(text: ".")
                        ],
                      ),
                      style: TextStyle(color: Color(0x66FFFFFF)),
                      textAlign: TextAlign.center,
                    ),
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
