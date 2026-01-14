import 'package:financial_planner_mobile/core/widgets/primary_button.dart';
import 'package:financial_planner_mobile/core/theme/theme.dart';
import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:financial_planner_mobile/features/auth/data/data_sources/remote/firebase_remote_data_source.dart';
import 'package:financial_planner_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/widgets/themed_input_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(
        AuthRepositoryImpl(
          AuthRemoteDataSourceImpl(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),
      ),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            Navigator.pop(context);
          }

          if (state is SignupError) {
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
        child: BlocBuilder<SignupCubit, SignupState>(
          builder: (context, state) {
            final pending = state is SignupLoading;

            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [darkTheme.secondary, Colors.transparent],
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
                                color: Colors.white,
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Create your account now!",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
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
                              context.read<SignupCubit>().signup(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    repeatPassword:
                                        repeatPasswordController.text,
                                  );
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
        ),
      ),
    );
  }
}
