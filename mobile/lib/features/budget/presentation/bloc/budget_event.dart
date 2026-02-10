part of 'budget_bloc.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();
  @override
  List<Object?> get props => [];
}

class UpdateBudgetEvent extends BudgetEvent {
  final Budget? budget;
  const UpdateBudgetEvent(this.budget);
  @override
  List<Object?> get props => [budget];
}
