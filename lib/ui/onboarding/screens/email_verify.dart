import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatelessWidget {
  const EmailVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/images/email.png',
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Email has been sent',
              style: TextStyle(
                fontSize: 25,
                color: darkTheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              textAlign: TextAlign.center,
              'Make sure to check your spam or junk folder',
              style: TextStyle(
                color: darkTheme.onSurfaceVariant,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
