import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:twoaxis_finance/features/account/presentation/pages/account.dart';
import 'package:twoaxis_finance/features/app_shell/presentation/widgets/navbar.dart';
import 'package:twoaxis_finance/features/dashboard/presentation/pages/dashboard.dart';
import 'package:twoaxis_finance/features/money_flow/presentation/pages/money_flow.dart';
import 'package:twoaxis_finance/features/onboarding/pages/onboarding.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/features/wallet/presentation/pages/wallet.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selected = 0;
  String? _lastUserId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserStateAuthenticated) {
          if (_lastUserId != state.user.id) {
            context.read<TransactionsBloc>().add(LoadTransactionsEvent());
            _lastUserId = state.user.id;
          }
        } else if (state is UserStateUnauthenticated) {
          _lastUserId = null;
        }
      },
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserStateUnauthenticated) {
            return const Onboarding();
          } else if (state is UserStateAuthenticated) {
            return Scaffold(
              body: IndexedStack(
                index: selected,
                children: const [
                  DashboardPage(),
                  MoneyFlowPage(),
                  Wallet(),
                  AccountPage(),
                ],
              ),
              bottomNavigationBar: Navbar(
                selected: selected,
                onTap: (page) {
                  setState(() {
                    selected = page;
                  });
                },
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
