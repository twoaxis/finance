import 'package:twoaxis_finance/core/values/categories.dart';
import 'package:flutter/material.dart';

IconData getCategoryIcon(String? categoryName,
    {IconData defaultIcon = Icons.category}) {
  if (categoryName == null) return defaultIcon;
  return expenseCategoryIcons[categoryName] ??
      incomeCategoryIcons[categoryName] ??
      defaultIcon;
}
