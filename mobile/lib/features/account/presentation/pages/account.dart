import 'package:twoaxis_finance/features/account/presentation/pages/account_currency.dart';
import 'package:twoaxis_finance/features/account/presentation/pages/account_settings.dart';
import 'package:twoaxis_finance/app/theme_cubit.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_repository.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/features/info/presentation/pages/info.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is! UserStateAuthenticated) return const SizedBox();

        var user = state.user;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(fullscreenSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary
                        ],
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    spacing: 10,
                    children: [
                      if (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                        ClipOval(
                          child: Image.network(
                            user.photoUrl!,
                            width: 60,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 60,
                                color: Theme.of(context).colorScheme.onPrimary,
                              );
                            },
                          ),
                        )
                      else
                        Icon(
                          Icons.person,
                          size: 60,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (user.name.isNotEmpty)
                              Text(
                                user.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            else
                              Text(
                                "No display name",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 24,
                                  fontStyle: FontStyle.italic,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            Text(
                              user.email,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountSettings(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          child: const Text("Account Settings"),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        height: 1,
                        thickness: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InfoPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          child: const Text("Info"),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        height: 1,
                        thickness: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountCurrency(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          child: const Text("Currency"),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.surface,
                        height: 1,
                        thickness: 3,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Dark Mode"),
                            Switch(
                              value: context.read<ThemeCubit>().state ==
                                  ThemeMode.dark,
                              onChanged: (val) {
                                context.read<ThemeCubit>().toggleTheme(val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    await context.read<AuthRepository>().logOut();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Text(
                      "Log out",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "(c) ${DateTime.now().year} TwoAxis. All Rights Reserved.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
