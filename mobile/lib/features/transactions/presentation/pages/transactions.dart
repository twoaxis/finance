import 'package:twoaxis_finance/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'package:twoaxis_finance/core/util/get_category_icon.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:twoaxis_finance/core/util/money_format.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TransactionsBloc>().add(LoadMoreTransactionsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(fullscreenSpacing),
          child: BlocBuilder<TransactionsBloc, TransactionsState>(
            builder: (BuildContext context, TransactionsState state) {
              if (state is TransactionsStateLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TransactionsStateError) {
                return Center(child: Text(state.message));
              } else if (state is TransactionsStateLoaded) {
                if (state.transactions.isEmpty) {
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
                            "No transactions",
                            style: TextStyle(fontSize: 25),
                          ),
                        )
                      ],
                    ),
                  );
                }

                var grouped = state.groupedTransactions;
                var sortedKeys = grouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: sortedKeys.length,
                        itemBuilder: (BuildContext context, int index) {
                          var dateKey = sortedKeys.elementAt(index);
                          var txList = grouped[dateKey]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMM d, y').format(dateKey),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...txList.map((tx) {
                                return GestureDetector(
                                  onLongPress: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16)),
                                      ),
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 180,
                                          padding: EdgeInsets.all(20),
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
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  context.read<TransactionsBloc>().add(DeleteTransactionEvent(tx.id));
                                                  Navigator.pop(context);
                                                },
                                                title: Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      spacing: 20,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.surfaceBright,
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Icon(
                                            getCategoryIcon(
                                              tx.category,
                                              defaultIcon: tx.type == TransactionType.expense
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
                                              Text(tx.name),
                                              Text(
                                                  DateFormat('MMM d, y. hh:mm a')
                                                      .format(tx.date),
                                                  style: TextStyle(
                                                      fontSize: 12, color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                        if (tx.type == TransactionType.expense)
                                          Text(
                                            "-${formatMoneyWithContext(context, tx.amount)}",
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )
                                        else if (tx.type == TransactionType.income)
                                          Text(
                                            "+${formatMoneyWithContext(context, tx.amount)}",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )
                                      ],
                                    ),
                                  ),
                                );
                              })
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(color: Theme.of(context).colorScheme.surfaceBright, height: 30);
                        },
                      ),
                    ),
                    if (!state.hasReachedMax)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
