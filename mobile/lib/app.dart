
import 'package:twoaxis_finance/core/util/theme.dart';
import 'package:twoaxis_finance/ui/onboarding/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
        debugShowCheckedModeBanner: false,
        title: "TwoAxis Finance",
        theme: ThemeData(
          splashFactory: NoSplash.splashFactory,
          colorScheme: darkTheme,
          useMaterial3: true,
        ),
        home: loggedIn ? const App() : const Onboarding());
  }
}
