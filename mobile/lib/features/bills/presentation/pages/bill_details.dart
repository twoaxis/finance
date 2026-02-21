import 'package:twoaxis_finance/features/bills/domain/entities/bill.dart';
import 'package:twoaxis_finance/features/bills/presentation/bloc/bills_bloc.dart';
import 'package:twoaxis_finance/features/bills/presentation/pages/bill_payment.dart';
import 'package:twoaxis_finance/core/widgets/primary_button.dart';
import 'package:twoaxis_finance/core/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twoaxis_finance/core/util/money_format.dart';

class BillDetails extends StatefulWidget {
  const BillDetails({super.key, required this.index, required this.bill});

  final int index;
  final Bill bill;

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  bool pending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill details"),
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
                        widget.bill.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Text(
                      formatMoneyWithContext(context, widget.bill.value),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                PrimaryButton(
                  text: "Pay bill",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BillPayment(bill: widget.bill, index: widget.index,),
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
                                      "Are you sure to delete this bill?"),
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
                                              context.read<BillsBloc>().add(RemoveBillEvent(widget.bill));
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
                      "Delete bill",
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
