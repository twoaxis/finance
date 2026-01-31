import 'package:flutter/material.dart';

/// Const map of expense category names to icons.
const Map<String, IconData> expenseCategoryIcons = {
  'Transportation': Icons.directions_car,
  'Food': Icons.restaurant,
  'Entertainment': Icons.movie,
  'Bills': Icons.receipt_long,
  'Shopping': Icons.shopping_bag,
  'Health': Icons.medical_services,
  'Education': Icons.school,
  'Housing': Icons.home,
  'Travel': Icons.flight,
  'Other': Icons.more_horiz,
};

/// Const map of income category names to icons.
const Map<String, IconData> incomeCategoryIcons = {
  'Salary': Icons.work,
  'Gift': Icons.card_giftcard,
  'Bonus': Icons.stars,
  'Investment': Icons.trending_up,
  'Freelance': Icons.laptop,
  'Refund': Icons.replay,
  'Other': Icons.more_horiz,
};

/// Gets the icon for a category by name.
/// Returns [defaultIcon] if the category name is null or not found.
IconData getCategoryIcon(String? categoryName,
    {IconData defaultIcon = Icons.category}) {
  if (categoryName == null) return defaultIcon;
  return expenseCategoryIcons[categoryName] ??
      incomeCategoryIcons[categoryName] ??
      defaultIcon;
}
