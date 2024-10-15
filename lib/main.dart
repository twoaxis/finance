import 'package:firebase_core/firebase_core.dart';
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

class FinancialPlanner extends StatelessWidget{
  const FinancialPlanner({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Planner',
      theme: ThemeData(
        colorScheme: lightTheme,
        useMaterial3: true,
      ),
      home: Onboarding()
    );
  }
}