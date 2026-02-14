import 'package:twoaxis_finance/features/receivables/presentation/pages/receivable_details.dart';
import 'package:twoaxis_finance/features/receivables/presentation/widgets/receivables_action_button.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/util/money_format.dart';

class ReceivablesPage extends StatefulWidget {
  const ReceivablesPage({super.key});

  @override
  State<ReceivablesPage> createState() => _ReceivablesPageState();
}

class _ReceivablesPageState extends State<ReceivablesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receivables"),
        backgroundColor: darkTheme.surfaceContainer,
        actions: [ReceivablesActionButton()],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
              if (state is! UserStateAuthenticated) {
                return const Center(child: CircularProgressIndicator());
              }

              var receivables = state.user.receivables;

              if (receivables.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "assets/images/empty_data.png",
                          width: 200,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Opacity(
                        opacity: 0.3,
                        child: Text(
                          "No receivables added",
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    ],
                  ),
                );
              }
              return ListView.separated(
                itemCount: receivables.length,
                itemBuilder: (context, index) {
                  var item = receivables[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceivableDetails(
                              index: index,
                              receivable: item,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(item.name,
                                  style: const TextStyle(fontSize: 15)),
                            ),
                            Text(
                              formatMoneyWithContext(
                                  context, item.value),
                              style: TextStyle(
                                color: darkTheme.primary,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios, size: 15)
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: darkTheme.surfaceContainer, height: 1);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
