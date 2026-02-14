import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';

class Transaction extends Equatable {
  final String id;
  final String name;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? category;
  final String? source;

  const Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.date,
    this.category,
    this.source,
  });

  @override
  List<Object?> get props => [id, name, amount, type, date, category, source];

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    // Handle both 'amount' and 'value' for backward compatibility
    var amountValue = data["amount"] ?? data["value"] ?? 0.0;

    return Transaction(
      id: doc.id,
      name: data["name"] ?? '',
      amount: (amountValue as num).toDouble(),
      type: TransactionType.values
          .firstWhere((element) => element.name == data["type"], orElse: () => TransactionType.expense),
      date: data["date"] != null ? (data["date"] as Timestamp).toDate() : DateTime.now(),
      category: data["category"],
      source: data["source"],
    );
  }
}
