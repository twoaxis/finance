import 'package:equatable/equatable.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_repository.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';
import 'dart:developer' as developer;

part "transactions_state.dart";
part "transactions_event.dart";

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionRepository _transactionRepository;

  TransactionsBloc({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository,
        super(TransactionsStateInitial()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(TransactionsStateLoading());
    try {
      var result = await _transactionRepository.getTransactions(limit: 30);
      var transactions = result['transactions'] as List<Transaction>;
      var lastDocument = result['lastDocument'];
      
      // Sort latest to oldest
      transactions.sort((a, b) => b.date.compareTo(a.date));
      
      developer.log("Loaded ${transactions.length} transactions");

      emit(TransactionsStateLoaded(
        transactions: transactions,
        groupedTransactions: _groupTransactions(transactions),
        hasReachedMax: transactions.length < 30,
        lastDocument: lastDocument,
      ));

    } catch (e, stackTrace) {
      developer.log("Error loading transactions", error: e, stackTrace: stackTrace);
      emit(TransactionsStateError(message: "Transactions failed to load: ${e.toString()}"));
    }
  }

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactionsEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    var currentState = state;
    if (currentState is TransactionsStateLoaded && !currentState.hasReachedMax) {
      try {
        var result = await _transactionRepository.getTransactions(
          limit: 30,
          startAfter: currentState.lastDocument,
        );
        var newTransactions = result['transactions'] as List<Transaction>;
        var lastDocument = result['lastDocument'];

        if (newTransactions.isEmpty) {
          emit(TransactionsStateLoaded(
            transactions: currentState.transactions,
            groupedTransactions: currentState.groupedTransactions,
            hasReachedMax: true,
            lastDocument: currentState.lastDocument,
          ));
        } else {
          var allTransactions = List<Transaction>.from(currentState.transactions)..addAll(newTransactions);
          allTransactions.sort((a, b) => b.date.compareTo(a.date));
          
          emit(TransactionsStateLoaded(
            transactions: allTransactions,
            groupedTransactions: _groupTransactions(allTransactions),
            hasReachedMax: newTransactions.length < 30,
            lastDocument: lastDocument,
          ));
        }
      } catch (e, stackTrace) {
        developer.log("Error loading more transactions", error: e, stackTrace: stackTrace);
      }
    }
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      var date = event.date ?? DateTime.now();
      var transactionId = await _transactionRepository.addTransaction(
        event.name,
        event.type,
        event.amount,
        source: event.source,
        category: event.category,
        date: date,
      );
      
      developer.log("Added transaction with ID: $transactionId");

      var newTransaction = Transaction(
        id: transactionId,
        name: event.name,
        type: event.type,
        amount: event.amount,
        date: date,
        source: event.source,
        category: event.category,
      );

      var currentState = state;
      if (currentState is TransactionsStateLoaded) {
        var updatedTransactions = List<Transaction>.from(currentState.transactions)
          ..add(newTransaction);
        
        // Sort latest to oldest
        updatedTransactions.sort((a, b) => b.date.compareTo(a.date));

        emit(TransactionsStateLoaded(
          transactions: updatedTransactions,
          groupedTransactions: _groupTransactions(updatedTransactions),
          hasReachedMax: currentState.hasReachedMax,
          lastDocument: currentState.lastDocument,
        ));
      } else {
        add(LoadTransactionsEvent());
      }
    } catch (e, stackTrace) {
      developer.log("Error adding transaction", error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await _transactionRepository.deleteTransaction(event.transactionId);
      developer.log("Deleted transaction with ID: ${event.transactionId}");

      var currentState = state;
      if (currentState is TransactionsStateLoaded) {
        var updatedTransactions = currentState.transactions
            .where((tx) => tx.id != event.transactionId)
            .toList();

        emit(TransactionsStateLoaded(
          transactions: updatedTransactions,
          groupedTransactions: _groupTransactions(updatedTransactions),
          hasReachedMax: currentState.hasReachedMax,
          lastDocument: currentState.lastDocument,
        ));
      } else {
        add(LoadTransactionsEvent());
      }
    } catch (e, stackTrace) {
      developer.log("Error deleting transaction", error: e, stackTrace: stackTrace);
    }
  }

  Map<DateTime, List<Transaction>> _groupTransactions(List<Transaction> list) {
    // Assuming list is already sorted, but we can sort again just in case
    var sortedList = List<Transaction>.from(list);
    sortedList.sort((a, b) => b.date.compareTo(a.date));

    Map<DateTime, List<Transaction>> grouped = {};
    for (var tx in sortedList) {
      var dateKey = DateTime(tx.date.year, tx.date.month, tx.date.day);
      if (!grouped.containsKey(dateKey)) grouped[dateKey] = [];
      grouped[dateKey]!.add(tx);
    }
    return grouped;
  }
}
