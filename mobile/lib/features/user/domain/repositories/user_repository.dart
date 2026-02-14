import 'package:twoaxis_finance/features/assets/domain/entities/asset.dart';
import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/bills/domain/entities/bill.dart';
import 'package:twoaxis_finance/features/budget/domain/entities/budget.dart';
import 'package:twoaxis_finance/features/income/domain/entities/income.dart';
import 'package:twoaxis_finance/features/liabilities/domain/entities/liability.dart';
import 'package:twoaxis_finance/features/receivables/domain/entities/receivable.dart';

abstract class UserRepository {
  Future<void> updateBalances(List<Balance> balances);
  Future<void> addBalance(Balance balance);
  Future<void> removeBalance(Balance balance);

  Future<void> updateIncome(List<Income> income);
  Future<void> addIncome(Income income);
  Future<void> removeIncome(Income income);

  Future<void> updateAssets(List<Asset> assets);
  Future<void> addAsset(Asset asset);
  Future<void> removeAsset(Asset asset);

  Future<void> updateBills(List<Bill> bills);
  Future<void> addBill(Bill bill);
  Future<void> removeBill(Bill bill);

  Future<void> updateReceivables(List<Receivable> receivables);
  Future<void> addReceivable(Receivable receivable);
  Future<void> removeReceivable(Receivable receivable);

  Future<void> updateLiabilities(List<Liability> liabilities);
  Future<void> addLiability(Liability liability);
  Future<void> removeLiability(Liability liability);

  Future<void> updateBudget(Budget? budget);
  Future<void> updateName(String name);
  Future<void> updateCurrency(String currency);
}
