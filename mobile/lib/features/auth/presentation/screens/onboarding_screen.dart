import 'package:financial_planner_mobile/core/widgets/primary_button.dart';
import 'package:financial_planner_mobile/features/auth/data/data_sources/remote/firebase_remote_data_source.dart';
import 'package:financial_planner_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:financial_planner_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:financial_planner_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:financial_planner_mobile/features/auth/presentation/screens/signup_screen.dart';
import 'package:financial_planner_mobile/core/theme/theme.dart';
import 'package:financial_planner_mobile/core/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(
        OnboardingRepositoryImpl(
          OnboardingRemoteDataSourceImpl(
            FirebaseAuth.instance,
            GoogleSignIn(),
          ),
        ),
      ),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            final loading = state is OnboardingLoading;

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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Image.asset("assets/images/logo.png"),
                                const Text(
                                  "TwoAxis Finance",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  "Your key to riches.",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: loading
                                    ? null
                                    : () {
                                        context
                                            .read<OnboardingCubit>()
                                            .signInWithGoogle();
                                      },
                                child: Image.asset(
                                  "assets/images/google.png",
                                  width: 70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Expanded(child: Divider(color: Colors.grey)),
                              Text("Or", style: TextStyle(color: Colors.grey)),
                              Expanded(child: Divider(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            text: "Login to your account",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkTheme.surfaceContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Create an account",
                                style: TextStyle(color: darkTheme.onPrimary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse(
                                "https://finance.twoaxis.org/privacy.html",
                              );
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                text:
                                    "By using our app, you're subject to our ",
                                children: [
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0x66FFFFFF),
                                      decorationThickness: 2,
                                    ),
                                  ),
                                  const TextSpan(text: "."),
                                ],
                              ),
                              style: const TextStyle(color: Color(0x66FFFFFF)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
