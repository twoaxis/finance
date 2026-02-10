import 'package:equatable/equatable.dart';
import 'package:twoaxis_finance/features/assets/domain/entities/asset.dart';
import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/bills/domain/entities/bill.dart';
import 'package:twoaxis_finance/features/budget/domain/entities/budget.dart';
import 'package:twoaxis_finance/features/income/domain/entities/income.dart';
import 'package:twoaxis_finance/features/liabilities/domain/entities/liability.dart';
import 'package:twoaxis_finance/features/receivables/domain/entities/receivable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String currency;
  final List<Balance> balances;
  final List<Income> income;
  final List<Asset> assets;
  final List<Bill> bills;
  final List<Receivable> receivables;
  final List<Liability> liabilities;
  final Budget? budget;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.balances = const [],
    this.income = const [],
    this.assets = const [],
    this.bills = const [],
    this.receivables = const [],
    this.liabilities = const [],
    this.budget,
    this.currency = "USD",
  });

  static const empty = User(
    id: '', 
    email: '', 
    name: '', 
    photoUrl: '',
    balances: [],
    income: [],
    assets: [],
    bills: [],
    receivables: [],
    liabilities: [],
    currency: 'USD',
  );

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? currency,
    List<Balance>? balances,
    List<Income>? income,
    List<Asset>? assets,
    List<Bill>? bills,
    List<Receivable>? receivables,
    List<Liability>? liabilities,
    Budget? budget,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      currency: currency ?? this.currency,
      balances: balances ?? this.balances,
      income: income ?? this.income,
      assets: assets ?? this.assets,
      bills: bills ?? this.bills,
      receivables: receivables ?? this.receivables,
      liabilities: liabilities ?? this.liabilities,
      budget: budget ?? this.budget,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "currency": currency,
      "balances": balances.map((e) => e.toFirestore()).toList(),
      "income": income.map((e) => e.toFirestore()).toList(),
      "assets": assets.map((e) => e.toFirestore()).toList(),
      "bills": bills.map((e) => e.toFirestore()).toList(),
      "receivables": receivables.map((e) => e.toFirestore()).toList(),
      "liabilities": liabilities.map((e) => e.toFirestore()).toList(),
      "budget": budget?.toFirestore(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        photoUrl,
        currency,
        balances,
        income,
        assets,
        bills,
        receivables,
        liabilities,
        budget
      ];
}
