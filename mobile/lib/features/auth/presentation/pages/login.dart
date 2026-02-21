import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/widgets/themed_input_field.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_repository.dart';
import 'package:twoaxis_finance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:twoaxis_finance/features/auth/presentation/pages/forget_password.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool pending = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
          if(state is AuthFailure) {
            _showErrorDialog(state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Theme.of(context).colorScheme.secondary, Colors.transparent],
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
                              icon: Icon(Icons.arrow_back),
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
                                Text(
                                  "Get back to your money!",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Login to your account",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(height: 40),
                                ThemedInputField(
                                  label: "E-mail",
                                  controller: emailController,
                                  placeholder: "john@hotmail.com",
                                  enabled: !pending,
                                  textInputAction: TextInputAction.next,
                                ),
                                SizedBox(height: 20),
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
                                        builder: (context) =>
                                            const ForgetPassword(),
                                      ),
                                    );
                                  },
                                  child: Text("Forgot password?"),
                                )
                              ],
                            ),
                          ),
                        ),
                        PrimaryButton(
                          text: "Login to your account",
                          enabled: !pending,
                          onPressed: () {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              return _showErrorDialog("Please fill all fields");
                            }

                            context.read<AuthBloc>().add(
                                  AuthLoginRequested(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
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
    );
  }
}
