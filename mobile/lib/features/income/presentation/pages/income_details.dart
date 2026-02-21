import 'package:twoaxis_finance/features/income/domain/entities/income.dart';
import 'package:twoaxis_finance/features/income/presentation/bloc/income_bloc.dart';
import 'package:twoaxis_finance/features/income/presentation/pages/income_payout.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/util/money_format.dart';

class IncomeDetails extends StatefulWidget {
  const IncomeDetails({super.key, required this.index, required this.income});

  final int index;
  final Income income;

  @override
  State<IncomeDetails> createState() => _IncomeDetailsState();
}

class _IncomeDetailsState extends State<IncomeDetails> {
  bool pending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Income source details"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(fullscreenSpacing),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.income.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Text(
                      formatMoneyWithContext(context, widget.income.value),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                PrimaryButton(
                  text: "Payout",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            IncomePayout(income: widget.income),
                      ),
                    );
                  },
                  enabled: !pending,
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: pending
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (BuildContext build) {
                                return AlertDialog(
                                  title: const Text(
                                      "Are you sure to delete this income source?"),
                                  icon: const Icon(Icons.delete),
                                  actions: [
                                    TextButton(
                                      onPressed: pending
                                          ? null
                                          : () {
                                              Navigator.of(context).pop();
                                            },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: pending
                                          ? null
                                          : ()  {
                                              context.read<IncomeBloc>().add(RemoveIncomeEvent(widget.income));
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              });
                        },
                  child: const Center(
                    child: Text(
                      "Delete income source",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
