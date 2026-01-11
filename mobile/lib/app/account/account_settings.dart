import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:financial_planner_mobile/core/widgets/primary_button.dart';
import 'package:financial_planner_mobile/core/widgets/themed_input_field.dart';
import 'package:financial_planner_mobile/app/onboarding/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/name_cubit.dart';
import '../../core/theme/theme.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool pending = false;
  String error = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account settings"),
        backgroundColor: darkTheme.surfaceContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(fullscreenSpacing),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ThemedInputField(
                        label: "Display name",
                        controller: nameController,
                        placeholder: "Jason",
                        enabled: !pending,
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext widget) {
                                return StatefulBuilder(
                                    builder: (context, setDialogState) {
                                  return AlertDialog(
                                    title: Text("Delete account?"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            "Enter your password to confirm account deletion?"),
                                        error.isNotEmpty
                                            ? Text(
                                                error,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20),
                                              )
                                            : const SizedBox(
                                                height: 20,
                                              ),
                                        ThemedInputField(
                                          enabled: !pending,
                                          obscureText: true,
                                          controller: passwordController,
                                          label: "Password",
                                          placeholder: "••••••••••",
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: pending
                                              ? null
                                              : () {
                                                  setDialogState(() {
                                                    pending = false;
                                                    error = "";
                                                  });

                                                  Navigator.pop(context);
                                                },
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: pending
                                              ? null
                                              : () async {
                                                  setDialogState(() {
                                                    pending = true;
                                                    error = "";
                                                  });

                                                  try {
                                                    var userCredential =
                                                        EmailAuthProvider.credential(
                                                            email: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .email!,
                                                            password:
                                                                passwordController
                                                                    .text);
                                                    await FirebaseAuth
                                                        .instance.currentUser!
                                                        .reauthenticateWithCredential(
                                                            userCredential);
                                                    await FirebaseAuth
                                                        .instance.currentUser!
                                                        .delete();

                                                    if (context.mounted) {
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Onboarding()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false,
                                                      );
                                                    }
                                                  } on FirebaseAuthException catch (e) {
                                                    if (e.code ==
                                                        'invalid-credential') {
                                                      setDialogState(() {
                                                        error =
                                                            "Invalid E-mail or password";
                                                      });
                                                      passwordController
                                                          .clear();
                                                    }
                                                  } finally {
                                                    setDialogState(() {
                                                      pending = false;
                                                    });
                                                  }
                                                },
                                          child: Text("Delete"))
                                    ],
                                  );
                                });
                              });
                        },
                        child: Center(
                          child: Text(
                            "Delete your account",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                  text: "Update account details",
                  onPressed: () async {
                    setState(() {
                      pending = true;
                    });
                    try {
                      context.read<NameCubit>().updateName(nameController.text);
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(nameController.text);

                      if (context.mounted) Navigator.pop(context);
                    } catch (error) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("An unknown error has occurred"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Okay"),
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
