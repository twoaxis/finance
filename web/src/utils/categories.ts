export const expenseCategoryIcons: Record<string, string> = {
  'Transportation': 'directions_car',
  'Food': 'restaurant',
  'Entertainment': 'movie',
  'Bills': 'receipt_long',
  'Shopping': 'shopping_bag',
  'Health': 'medical_services',
  'Education': 'school',
  'Housing': 'home',
  'Travel': 'flight',
  'Other': 'more_horiz',
};

export const incomeCategoryIcons: Record<string, string> = {
  'Salary': 'work',
  'Gift': 'card_giftcard',
  'Bonus': 'stars',
  'Investment': 'trending_up',
  'Freelance': 'laptop',
  'Refund': 'replay',
  'Other': 'more_horiz',
};

export function getCategoryIcon(category: string | undefined | null, defaultIcon: string = 'category'): string {
  if (!category) return defaultIcon;
  return expenseCategoryIcons[category] ?? incomeCategoryIcons[category] ?? defaultIcon;
}
