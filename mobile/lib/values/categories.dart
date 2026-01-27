import 'package:flutter/material.dart';

/// Represents a transaction category with a name and icon.
class Category {
  final String name;
  final IconData icon;

  const Category({
    required this.name,
    required this.icon,
  });
}

/// Predefined expense categories
const List<Category> expenseCategories = [
  Category(name: 'Transportation', icon: Icons.directions_car),
  Category(name: 'Food', icon: Icons.restaurant),
  Category(name: 'Entertainment', icon: Icons.movie),
  Category(name: 'Bills', icon: Icons.receipt_long),
  Category(name: 'Shopping', icon: Icons.shopping_bag),
  Category(name: 'Health', icon: Icons.medical_services),
  Category(name: 'Education', icon: Icons.school),
  Category(name: 'Housing', icon: Icons.home),
  Category(name: 'Travel', icon: Icons.flight),
  Category(name: 'Other', icon: Icons.more_horiz),
];

/// Predefined income categories
const List<Category> incomeCategories = [
  Category(name: 'Salary', icon: Icons.work),
  Category(name: 'Gift', icon: Icons.card_giftcard),
  Category(name: 'Bonus', icon: Icons.stars),
  Category(name: 'Investment', icon: Icons.trending_up),
  Category(name: 'Freelance', icon: Icons.laptop),
  Category(name: 'Refund', icon: Icons.replay),
  Category(name: 'Other', icon: Icons.more_horiz),
];

/// Map of category names to their icons for quick lookup
final Map<String, IconData> _categoryIconMap = {
  for (final category in [...expenseCategories, ...incomeCategories])
    category.name: category.icon,
};

/// Gets the icon for a category by name.
/// Returns default icon if the category name is null or not found.
IconData getCategoryIcon(String? categoryName,
    {IconData defaultIcon = Icons.category}) {
  if (categoryName == null) return defaultIcon;
  return _categoryIconMap[categoryName] ?? defaultIcon;
}
