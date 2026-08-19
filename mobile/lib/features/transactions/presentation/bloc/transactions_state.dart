part of "transactions_bloc.dart";

abstract class TransactionsState extends Equatable {
  const TransactionsState();
  @override
  List<Object?> get props => [];
}

class TransactionsStateInitial extends TransactionsState {}

class TransactionsStateLoading extends TransactionsState {}

class TransactionsStateLoaded extends TransactionsState {
  final List<Transaction> transactions;
  final Map<DateTime, List<Transaction>> groupedTransactions;
  final bool hasReachedMax;
  final Object? lastDocument;

  const TransactionsStateLoaded({
    required this.transactions, 
    required this.groupedTransactions,
    this.hasReachedMax = false,
    this.lastDocument,
  });

  @override
  List<Object?> get props => [transactions, groupedTransactions, hasReachedMax, lastDocument];
}

class TransactionsStateError extends TransactionsState {
  final String message;

  const TransactionsStateError({required this.message});

  @override
  List<Object?> get props => [message];
}
