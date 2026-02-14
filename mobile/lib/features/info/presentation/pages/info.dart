import 'package:twoaxis_finance/app/theme.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "About",
          ),
          backgroundColor: darkTheme.surfaceContainer,
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text("Version",
                  style: TextStyle(color: darkTheme.onSurfaceVariant)),
              subtitle: Text("1.2.1",
                  style: TextStyle(color: darkTheme.onSurfaceVariant)),
              leading: Icon(Icons.build, color: darkTheme.onSurfaceVariant),
              onTap: () {},
            ),
            Divider(color: darkTheme.surfaceContainer, height: 1),
            ListTile(
              title: Text("Build Number",
                  style: TextStyle(color: darkTheme.onSurfaceVariant)),
              subtitle: Text("17",
                  style: TextStyle(color: darkTheme.onSurfaceVariant)),
              leading: Icon(Icons.build, color: darkTheme.onSurfaceVariant),
              onTap: () {},
            ),
            Divider(color: darkTheme.surfaceContainer, height: 1),
            const SizedBox(height: 30),
            Text(
              "(c) ${DateTime.now().year} TwoAxis. All Rights Reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(color: darkTheme.onSurfaceVariant),
            ),
          ],
        ));
  }
}
