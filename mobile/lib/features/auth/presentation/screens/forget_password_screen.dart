// presentation/screens/forget_password.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/core/widgets/primary_button.dart';
import 'package:financial_planner_mobile/core/widgets/themed_input_field.dart';
import 'package:financial_planner_mobile/features/auth/data/data_sources/remote/firebase_remote_data_source.dart';
import 'package:financial_planner_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:financial_planner_mobile/features/auth/presentation/screens/email_sent_screen.dart';
import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordCubit(
        AuthRepositoryImpl(
          AuthRemoteDataSourceImpl(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),
      ),
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const EmailSent(),
              ),
            );
          }

          if (state is ForgetPasswordError) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Error"),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Okay"),
                  )
                ],
              ),
            );
          }
        },
        child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
          builder: (context, state) {
            final pending = state is ForgetPasswordLoading;

            return Scaffold(
              appBar: AppBar(),
              body: SafeArea(
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
                                width: 200,
                              ),
                              const Text(
                                "Everybody forgets!",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "We'll help you get right back.",
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
                          context.read<ForgetPasswordCubit>().resetPassword(
                                emailController.text,
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
