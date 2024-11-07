import 'package:financial_planner_mobile/ui/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_planner_mobile/ui/onboarding/onboarding.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FinancialPlanner());
}

class FinancialPlanner extends StatefulWidget{
  const FinancialPlanner({super.key});

  @override
  State<FinancialPlanner> createState() => _FinancialPlannerState();
}

class _FinancialPlannerState extends State<FinancialPlanner> {

  bool loggedIn = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {

      setState(() {
        loggedIn = (user != null);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Planner',
      theme: ThemeData(
        colorScheme: darkTheme,
        useMaterial3: true,
      ),
      home: loggedIn ? const App() : const Onboarding()
    );
  }
}