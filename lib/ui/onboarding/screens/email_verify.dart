import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatelessWidget {
  const EmailVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: darkTheme.primary,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Image.asset(
              'asset/images/email.png',
            ),
            SizedBox(
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
            SizedBox(
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
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
