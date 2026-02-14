part of 'balances_bloc.dart';

abstract class BalancesState extends Equatable {
  const BalancesState();
  @override
  List<Object?> get props => [];
}

class BalancesInitial extends BalancesState {
  const BalancesInitial();
}
class BalancesActionPending extends BalancesState {
  const BalancesActionPending();
}
class BalancesActionSuccess extends BalancesState {
  const BalancesActionSuccess();
}
class BalancesActionFailure extends BalancesState {
  final String message;
  const BalancesActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
