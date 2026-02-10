part of 'balances_bloc.dart';

abstract class BalancesEvent extends Equatable {
  const BalancesEvent();
  @override
  List<Object> get props => [];
}

class AddBalanceEvent extends BalancesEvent {
  final Balance balance;
  const AddBalanceEvent(this.balance);
  @override
  List<Object> get props => [balance];
}

class RemoveBalanceEvent extends BalancesEvent {
  final Balance balance;
  const RemoveBalanceEvent(this.balance);
  @override
  List<Object> get props => [balance];
}

class UpdateBalancesListEvent extends BalancesEvent {
  final List<Balance> balancesList;
  const UpdateBalancesListEvent(this.balancesList);
  @override
  List<Object> get props => [balancesList];
}
