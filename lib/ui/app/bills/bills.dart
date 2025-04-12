import 'package:financial_planner_mobile/cubit/bills_cubit.dart';
import 'package:financial_planner_mobile/ui/app/bills/bill_details.dart';
import 'package:financial_planner_mobile/ui/app/bills/bills_action_button.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
        backgroundColor: darkTheme.surfaceContainer,
        actions: [BillsActionButton()],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: BlocBuilder<BillsCubit, List<dynamic>>(
              builder: (context, bills) {
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
                                bill: bills[index],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(bills[index]["name"],
                                    style: const TextStyle(fontSize: 15)),
                              ),
                              Text(
                                "\$${bills[index]["value"] is int ? NumberFormat('#,##0').format(bills[index]["value"]) : NumberFormat('#,##0.##').format((bills[index]["value"] as num).toDouble())}",
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
                    return Divider(
                        color: darkTheme.surfaceContainer, height: 1);
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
