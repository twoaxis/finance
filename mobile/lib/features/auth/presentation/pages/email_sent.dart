import 'package:twoaxis_finance/app/theme.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmailSent extends StatelessWidget {
  const EmailSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(fullscreenSpacing),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/email_sent.json',
                width: 250
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Email has been sent',
                style: TextStyle(
                  fontSize: 30,
                  color: darkTheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                'Make sure to check your spam or junk folder.',
                style: TextStyle(
                  color: darkTheme.onSurfaceVariant,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
