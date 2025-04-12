import 'package:financial_planner_mobile/cubit/income_cubit.dart';
import 'package:financial_planner_mobile/ui/app/income/income_action_button.dart';
import 'package:financial_planner_mobile/ui/app/income/income_details.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Income"),
        backgroundColor: darkTheme.surfaceContainer,
        actions: [IncomeActionButton()],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: BlocBuilder<IncomeCubit, List<dynamic>>(
              builder: (context, income) {
                if (income.isEmpty) {
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
                        SizedBox(height: 20,),
                        Opacity(
                          opacity: 0.3,
                          child: Text("No income added", style: TextStyle(fontSize: 25),),
                        )
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: income.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IncomeDetails(
                                index: index,
                                income: income[index],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(income[index]["name"],
                                    style: const TextStyle(fontSize: 15)),
                              ),
                              Text(
                                "\$${income[index]["value"] is int ? NumberFormat('#,##0').format(income[index]["value"]) : NumberFormat('#,##0.##').format((income[index]["value"] as num).toDouble())}",
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
