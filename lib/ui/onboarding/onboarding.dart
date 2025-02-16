import 'package:financial_planner_mobile/ui/onboarding/screens/login.dart';
import 'package:financial_planner_mobile/ui/onboarding/screens/signup.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int page = 0;

  void changePage(int x) {
    setState(() {
      page = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("asset/images/onboarding.png"),
                fit: BoxFit.cover,
                alignment: Alignment.center)),
        child: Container(
          padding: EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xFF000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "TwoAxis Finance",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Text(
                "Manage your income, expenses and assets with ease!",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
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
                      elevation: 3),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "Login to your account",
                    style: TextStyle(color: darkTheme.onPrimary),
                  ),
                ),
              ),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
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
                  final Uri uri =
                      Uri.parse("https://finance.twoaxis.org/privacy.html");

                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: Text.rich(
                  TextSpan(
                    text: "By using our app, you're subject to our ",
                    // Normal text
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
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
