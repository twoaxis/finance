import 'package:twoaxis_finance/features/dashboard/presentation/widgets/dashboard_button.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_cubit.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';
import 'package:twoaxis_finance/features/analytics/presentation/pages/analytics.dart';
import 'package:twoaxis_finance/features/budget/presentation/pages/budget.dart';
import 'package:twoaxis_finance/features/quick_add/presentation/pages/quick_add_expense.dart';
import 'package:twoaxis_finance/features/quick_add/presentation/pages/quick_add_income.dart';
import 'package:twoaxis_finance/features/transactions/presentation/pages/transactions.dart';
import 'package:twoaxis_finance/core/util/get_category_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:twoaxis_finance/core/util/money_format.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {

        if(userState is !UserStateAuthenticated) return const SizedBox();

        return Stack(
          children: [
            Container(
              height: 500,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Theme.of(context).colorScheme.primary, Colors.transparent],
                  radius: 1,
                  center: Alignment.topCenter,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        const Text("Total balance"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 50,
                            ),
                            if (isHidden)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.5),
                                child: Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              )
                            else
                              Text(
                                formatMoneyWithContext(
                                    context,
                                    userState.user.balances.fold<double>(
                                        0, (sum, balance) => sum + balance.value)),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 40),
                              ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isHidden = !isHidden;
                                });
                              },
                              color: Colors.white,
                              icon: Icon(isHidden
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DashboardButton(
                              icon: Icons.add,
                              name: "Quick Add",
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 300,
                                      padding: const EdgeInsets.all(20),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                              BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const QuickAddIncome()));
                                            },
                                            title: const Text("Income"),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const QuickAddExpense()));
                                            },
                                            title: const Text("Expense"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            DashboardButton(
                              icon: Icons.analytics,
                              name: "Analytics",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const AnalyticsPage()));
                              },
                            ),
                            DashboardButton(
                              icon: Icons.money_off_csred,
                              name: "Budget",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const BudgetPage()));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionsPage(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Expanded(
                            child: Text(
                              "Recent Transactions",
                              style: TextStyle(fontSize: 15),
                            )),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: BlocBuilder<TransactionsBloc, TransactionsState>(
                      builder: (context, transactionsState) {
                        if (transactionsState is TransactionsStateLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (transactionsState is TransactionsStateError) {
                          return Center(
                            child: Text(transactionsState.message),
                          );
                        } else if (transactionsState is TransactionsStateLoaded) {
                          if (transactionsState.transactions.isEmpty) {
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Opacity(
                                    opacity: 0.3,
                                    child: Text(
                                      "No transactions",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: transactionsState.transactions.length <= 30
                                ? transactionsState.transactions.length
                                : 30,
                            itemBuilder: (context, index) {
                              var item = transactionsState.transactions[index];
                              return Row(
                                spacing: 10,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surfaceBright,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: Icon(
                                      getCategoryIcon(
                                        item.category,
                                        defaultIcon:
                                        item.type ==
                                            TransactionType.expense
                                            ? Icons.payments_rounded
                                            : Icons.file_download_rounded,
                                      ),
                                      size: 25,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name),
                                        Text(
                                            DateFormat('MMM d, y. hh:mm a')
                                                .format(item.date),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey))
                                      ],
                                    ),
                                  ),
                                  if (item.type ==
                                      TransactionType.expense)
                                    Text(
                                      "-${formatMoneyWithContext(context, item.amount)}",
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  else if (item.type ==
                                      TransactionType.income)
                                    Text(
                                      "+${formatMoneyWithContext(context, item.amount)}",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                  color: Theme.of(context).colorScheme.surfaceBright, height: 20);
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }
    );
  }
}
