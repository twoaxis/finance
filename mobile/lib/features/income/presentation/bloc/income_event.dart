part of 'income_bloc.dart';

abstract class IncomeEvent extends Equatable {
  const IncomeEvent();

  @override
  List<Object> get props => [];
}

class AddIncomeEvent extends IncomeEvent {
  final Income income;
  const AddIncomeEvent(this.income);

  @override
  List<Object> get props => [income];
}

class RemoveIncomeEvent extends IncomeEvent {
  final Income income;
  const RemoveIncomeEvent(this.income);

  @override
  List<Object> get props => [income];
}

class UpdateIncomeListEvent extends IncomeEvent {
  final List<Income> incomeList;
  const UpdateIncomeListEvent(this.incomeList);

  @override
  List<Object> get props => [incomeList];
}
