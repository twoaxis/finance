part of 'income_bloc.dart';

abstract class IncomeState extends Equatable {
  const IncomeState();
  
  @override
  List<Object?> get props => [];
}

class IncomeInitial extends IncomeState {
  const IncomeInitial();
}

class IncomeActionPending extends IncomeState {
  const IncomeActionPending();
}

class IncomeActionSuccess extends IncomeState {
  const IncomeActionSuccess();
}

class IncomeActionFailure extends IncomeState {
  final String message;
  const IncomeActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
