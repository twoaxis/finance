import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_planner_mobile/ui/app/expense_sheets/expense_sheet_add_item.dart';
import 'package:financial_planner_mobile/ui/app/expense_sheets/expense_sheets_add.dart';

import 'package:flutter/material.dart';

class ExpenseSheetItemsActionButton extends StatelessWidget {
  const ExpenseSheetItemsActionButton({super.key, required this.sheet});

  final DocumentSnapshot sheet;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseSheetAddItem(sheet: sheet),
          ),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
