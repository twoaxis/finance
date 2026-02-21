import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/features/account/presentation/bloc/account_bloc.dart';
import 'package:twoaxis_finance/features/onboarding/pages/onboarding.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';

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
    var state = context.read<UserCubit>().state;
    if (state is UserStateAuthenticated) {
      nameController.text = state.user.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountActionPending) {
          setState(() {
            pending = true;
          });
        } else if (state is AccountActionSuccess) {
          setState(() {
            pending = false;
          });
          Navigator.of(context).pop();
        } else if (state is AccountActionFailure) {
          setState(() {
            pending = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Account settings"),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext widget) {
                                  return StatefulBuilder(
                                      builder: (context, setDialogState) {
                                        return AlertDialog(
                                          title: const Text("Delete account?"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                  "Enter your password to confirm account deletion?"),
                                              error.isNotEmpty
                                                  ? Text(
                                                error,
                                                style: const TextStyle(
                                                    color: Colors.red, fontSize: 20),
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
                                                child: const Text("Cancel")),
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
                                                        email: FirebaseAuth.instance
                                                            .currentUser!.email!,
                                                        password:
                                                        passwordController.text);
                                                    await FirebaseAuth
                                                        .instance.currentUser!
                                                        .reauthenticateWithCredential(
                                                        userCredential);
                                                    await FirebaseAuth
                                                        .instance.currentUser!
                                                        .delete();

                                                    if (context.mounted) {
                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Onboarding()),
                                                            (Route<dynamic> route) =>
                                                        false,
                                                      );
                                                    }
                                                  } on FirebaseAuthException catch (e) {
                                                    if (e.code == 'invalid-credential') {
                                                      setDialogState(() {
                                                        error =
                                                        "Invalid E-mail or password";
                                                      });
                                                      passwordController.clear();
                                                    }
                                                  } finally {
                                                    setDialogState(() {
                                                      pending = false;
                                                    });
                                                  }
                                                },
                                                child: const Text("Delete"))
                                          ],
                                        );
                                      });
                                });
                          },
                          child: const Center(
                            child: Text("Delete your account", style: TextStyle(
                              color: Colors.red
                            ),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                PrimaryButton(
                    text: "Update account details",
                    enabled: !pending,
                    onPressed: () async {
                      context.read<AccountBloc>().add(UpdateNameEvent(nameController.text));
                      // We still want to update FirebaseAuth display name for completeness
                      await FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
