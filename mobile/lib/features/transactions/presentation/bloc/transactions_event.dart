part of "transactions_bloc.dart";

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionsEvent {}

class AddTransactionEvent extends TransactionsEvent {
  final String name;
  final TransactionType type;
  final double amount;
  final String? source;
  final String? category;
  final DateTime? date;

  const AddTransactionEvent({
    required this.name,
    required this.type,
    required this.amount,
    this.source,
    this.category,
    this.date,
  });

  @override
  List<Object?> get props => [name, type, amount, source, category, date];
}

class DeleteTransactionEvent extends TransactionsEvent {
  final String transactionId;

  const DeleteTransactionEvent(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}
