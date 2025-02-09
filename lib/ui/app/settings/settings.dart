import 'package:financial_planner_mobile/ui/onboarding/onboarding.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  var passwordController = TextEditingController();
  var pending = false;
  var error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          backgroundColor: darkTheme.surfaceContainer,
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text("Delete your account",
                  style: TextStyle(color: darkTheme.error)),
              leading: Icon(Icons.delete, color: darkTheme.error),
              onTap: () {
                showDialog(context: context, builder: (BuildContext widget) {
                  return StatefulBuilder(builder: (context, setDialogState) {
                    return AlertDialog(
                      title: Text("Delete account?"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Enter your password to confirm account deletion?"),
                          error.isNotEmpty
                              ? Text(
                            error,
                            style: const TextStyle(color: Colors.red, fontSize: 20),
                          )
                              : const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            enabled: !pending,
                            obscureText: true,
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: "••••••••••",
                              labelText: "Password",
                            ),
                          )
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: pending ? null : () {
                          setDialogState(() {
                            pending = false;
                            error = "";
                          });

                          Navigator.pop(context);
                        }, child: Text("Cancel")),
                        TextButton(onPressed: pending ? null : () async {

                          setDialogState(() {
                            pending = true;
                            error = "";
                          });

                          try {
                            var userCredential = EmailAuthProvider.credential(email: FirebaseAuth.instance.currentUser!.email!, password: passwordController.text);
                            await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(userCredential);
                            await FirebaseAuth.instance.currentUser!.delete();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Onboarding()), // Replace with your login screen
                                  (Route<dynamic> route) => false, // Remove all previous routes
                            );

                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-credential') {
                              setDialogState(() {
                                error = "Invalid E-mail or password";
                              });
                              passwordController.clear();
                            }
                          } finally {
                            setDialogState(() {
                              pending = false;
                            });
                          }
                        }, child: Text("Delete"))
                      ],
                    );
                  });
                });
              },
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
