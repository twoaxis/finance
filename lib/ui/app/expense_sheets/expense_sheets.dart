import 'package:financial_planner_mobile/cubit/expenses_cubit.dart';
import 'package:financial_planner_mobile/ui/app/expense_sheets/expense_sheet_items.dart';
import 'package:financial_planner_mobile/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseSheetsPage extends StatefulWidget {
  const ExpenseSheetsPage({super.key});

  @override
  State<ExpenseSheetsPage> createState() => _ExpenseSheetsPageState();
}

class _ExpenseSheetsPageState extends State<ExpenseSheetsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ExpensesCubit, List<dynamic>>(
            builder: (context, expenses) {
              return ListView.separated(
                itemCount: expenses.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(expenses[index].data()["name"]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpenseSheetItems(sheetIndex: index),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Theme.of(context).colorScheme.surfaceContainer, height: 1);
                },
              );
            },
          ),
        )
      ],
    );
  }
}
