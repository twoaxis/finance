part of 'budget_bloc.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();
  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {
  const BudgetInitial();
}
class BudgetActionPending extends BudgetState {
  const BudgetActionPending();
}
class BudgetActionSuccess extends BudgetState {
  const BudgetActionSuccess();
}
class BudgetActionFailure extends BudgetState {
  final String message;
  const BudgetActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
