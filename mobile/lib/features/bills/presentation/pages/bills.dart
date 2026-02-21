import 'package:twoaxis_finance/features/bills/presentation/pages/bill_details.dart';
import 'package:twoaxis_finance/features/bills/presentation/widgets/bills_action_button.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/util/money_format.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bills"),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [BillsActionButton()],
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

                var bills = state.user.bills;

                if (bills.isEmpty) {
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
                            "No bills added",
                            style: TextStyle(fontSize: 25),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    var item = bills[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillDetails(
                                index: index,
                                bill: item,
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
                                formatMoneyWithContext(context, item.value),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
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
                    return Divider(
                        color: Theme.of(context).colorScheme.surfaceContainer, height: 1);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
