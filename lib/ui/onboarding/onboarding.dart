import 'package:financial_planner_mobile/ui/onboarding/screens/login.dart';
import 'package:financial_planner_mobile/ui/onboarding/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: IndexedStack(
          index: page,
          children: [
            LoginPage(changePage: changePage),
            SignupPage(changePage: changePage)
          ],
        )
      )
    );
  }
}