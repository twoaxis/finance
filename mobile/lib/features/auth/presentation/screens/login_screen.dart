import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/core/widgets/primary_button.dart';
import 'package:financial_planner_mobile/core/widgets/themed_input_field.dart';
import 'package:financial_planner_mobile/features/auth/data/data_sources/remote/firebase_remote_data_source.dart';
import 'package:financial_planner_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:financial_planner_mobile/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:financial_planner_mobile/core/theme/theme.dart';
import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        AuthRepositoryImpl(
          AuthRemoteDataSourceImpl(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pop(context);
          }

          if (state is LoginError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Okay"),
                    )
                  ],
                );
              },
            );
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final bool pending = state is LoginLoading;

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
                            flex: 1,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/logo.png"),
                                  const Text(
                                    "Get back to your money!",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "Login to your account",
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
                                    textInputAction: TextInputAction.done,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgetPassword(),
                                        ),
                                      );
                                    },
                                    child: const Text("Forgot password?"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          PrimaryButton(
                            text: "Login to your account",
                            enabled: !pending,
                            onPressed: () {
                              context.read<LoginCubit>().login(
                                    email: emailController.text,
                                    password: passwordController.text,
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
