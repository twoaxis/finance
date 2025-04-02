import 'package:financial_planner_mobile/cubit/name_cubit.dart';
import 'package:financial_planner_mobile/ui/app/account/account_settings.dart';
import 'package:financial_planner_mobile/ui/app/info/info.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:financial_planner_mobile/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(fullscreenSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: darkTheme.surfaceContainer,
                  gradient: LinearGradient(
                    colors: [darkTheme.primary, darkTheme.secondary],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                spacing: 10,
                children: [
                  if (FirebaseAuth.instance.currentUser!.photoURL != null)
                    ClipOval(
                      child: Image.network(
                        FirebaseAuth.instance.currentUser!.photoURL!,
                        width: 60,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Icon(Icons.person, size: 60);
                        },
                      ),
                    )
                  else
                    Icon(Icons.person, size: 60),
                  Flexible(
                    child: BlocBuilder<NameCubit, String?>(
                      builder: (BuildContext context, String? name) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(name != null && name.isNotEmpty)
                              Text(
                                name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ) else
                              Text(
                                "No display name",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal, fontSize: 24, fontStyle: FontStyle.italic),
                              ),
                            Text(FirebaseAuth.instance.currentUser!.email!)
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: darkTheme.surfaceBright,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountSettings(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      child: Text("Account Settings"),
                    ),
                  ),
                  Divider(color: darkTheme.surface, height: 1, thickness: 3,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InfoPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      child: Text("Info"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: darkTheme.surfaceBright,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text("Log out", style: TextStyle(color: Colors.red),),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "(c) ${DateTime.now().year} TwoAxis. All Rights Reserved.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: darkTheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
