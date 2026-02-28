import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/app/theme_cubit.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_repository.dart';
import 'package:twoaxis_finance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:twoaxis_finance/features/auth/presentation/pages/email_sent.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    super.key,
  });

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();

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
            if (state.message == "E-mail does not exist") {
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmailSent(),
                ),
              );
            } else {
              _showErrorDialog(state.message);
            }
          } else if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const EmailSent(),
              ),
            );
          }
        },
        builder: (context, state) {
          bool pending = state is AuthLoading;

          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, theme) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
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
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                        "assets/animations/forgot_password.json",
                                        width: 200),
                                    const Text(
                                      "Everybody forgets!",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "We'll help you get right back.",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    ThemedInputField(
                                      label: "E-mail",
                                      controller: emailController,
                                      placeholder: "john@hotmail.com",
                                      enabled: !pending,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PrimaryButton(
                              text: "Reset Password",
                              enabled: !pending,
                              onPressed: () {
                                if (emailController.text.isEmpty) {
                                  _showErrorDialog("Please enter your e-mail");
                                } else {
                                  context.read<AuthBloc>().add(
                                        AuthPasswordResetRequested(
                                          email: emailController.text,
                                        ),
                                      );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
