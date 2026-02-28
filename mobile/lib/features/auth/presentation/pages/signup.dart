import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/app/theme_cubit.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';

import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_repository.dart';
import 'package:twoaxis_finance/features/auth/presentation/bloc/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthBloc(authRepository: context.read<AuthRepository>()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            _showErrorDialog(state.message);
          } else if (state is AuthSuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          bool pending = state is AuthLoading;

          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, theme) {
              return Scaffold(
                body: Stack(
                  children: [
                    if (theme == ThemeMode.dark)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Theme.of(context).colorScheme.secondary,
                              Colors.transparent
                            ],
                            radius: 1,
                            center: Alignment.topCenter,
                          ),
                        ),
                      ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(fullscreenSpacing),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                )
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Image.asset("assets/images/logo.png"),
                                      const Text(
                                        "The next step to riches!",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        "Create your account now!",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(height: 40),
                                      ThemedInputField(
                                        label: "E-mail",
                                        controller: emailController,
                                        placeholder: "john@hotmail.com",
                                        enabled: !pending,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 20),
                                      ThemedInputField(
                                        label: "Password",
                                        controller: passwordController,
                                        placeholder: "•••••••••••",
                                        enabled: !pending,
                                        obscureText: true,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 20),
                                      ThemedInputField(
                                        label: "Repeat Password",
                                        controller: repeatPasswordController,
                                        placeholder: "•••••••••••",
                                        enabled: !pending,
                                        obscureText: true,
                                        textInputAction: TextInputAction.done,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            PrimaryButton(
                              text: "Create your account",
                              enabled: !pending,
                              onPressed: () {
                                if (emailController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    repeatPasswordController.text.isEmpty) {
                                  _showErrorDialog("Please fill all fields");
                                } else if (passwordController.text !=
                                    repeatPasswordController.text) {
                                  _showErrorDialog("Passwords don't match");
                                } else {
                                  context.read<AuthBloc>().add(
                                        AuthSignupRequested(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ),
                                      );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
