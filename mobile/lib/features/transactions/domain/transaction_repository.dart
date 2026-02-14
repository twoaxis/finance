import 'package:twoaxis_finance/features/transactions/domain/transaction.dart';
import 'package:twoaxis_finance/features/transactions/domain/transaction_type.dart';

abstract class TransactionRepository {

  Future<List<Transaction>> getAllTransactions();
  Future<String> addTransaction(String name, TransactionType type, double amount, {String? source, String? category, DateTime? date});
  Future<void> deleteTransaction(String id);
}
