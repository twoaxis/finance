import 'package:twoaxis_finance/ui/app/assets/assets.dart';
import 'package:twoaxis_finance/ui/app/balances/balances.dart';
import 'package:twoaxis_finance/ui/app/income/income.dart';
import 'package:twoaxis_finance/ui/app/receivables/receivables.dart';
import 'package:twoaxis_finance/core/util/theme.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(fullscreenSpacing),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wallet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IncomePage()));
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: darkTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Income sources",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage your various income sources.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/income.png',
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BalancesPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: darkTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Balances",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage your balances.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/balances.png',
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReceivablesPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: darkTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receivables",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage money owed to you.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/receivables.png',
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AssetsPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: darkTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Assets",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage everything you own.",
                              style:
                              TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/assets.png',
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
