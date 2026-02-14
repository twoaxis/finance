import 'package:twoaxis_finance/features/receivables/domain/entities/receivable.dart';
import 'package:twoaxis_finance/features/receivables/presentation/bloc/receivables_bloc.dart';
import 'package:twoaxis_finance/features/receivables/presentation/pages/receivable_payout.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/util/money_format.dart';
import 'package:twoaxis_finance/app/theme.dart';

class ReceivableDetails extends StatefulWidget {
  const ReceivableDetails({super.key, required this.index, required this.receivable});

  final int index;
  final Receivable receivable;

  @override
  State<ReceivableDetails> createState() => _ReceivableDetailsState();
}

class _ReceivableDetailsState extends State<ReceivableDetails> {
  bool pending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receivable details"),
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
                        widget.receivable.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Text(
                      formatMoneyWithContext(context, widget.receivable.value),
                      style: TextStyle(
                        color: darkTheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                PrimaryButton(
                  text: "Pay",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReceivablePay(index: widget.index, receivable: widget.receivable),
                      ),
                    );
                  },
                  enabled: !pending,
                ),
                SizedBox(
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
                                      "Are you sure to delete this receivable?"),
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
                                              context.read<ReceivablesBloc>().add(RemoveReceivableEvent(widget.receivable));
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              });
                        },
                  child: Center(
                    child: Text(
                      "Delete receivable",
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
