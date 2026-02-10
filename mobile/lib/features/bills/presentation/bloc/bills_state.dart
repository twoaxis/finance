part of 'bills_bloc.dart';

abstract class BillsState extends Equatable {
  const BillsState();
  @override
  List<Object?> get props => [];
}

class BillsInitial extends BillsState {
  const BillsInitial();
}
class BillsActionPending extends BillsState {
  const BillsActionPending();
}
class BillsActionSuccess extends BillsState {
  const BillsActionSuccess();
}
class BillsActionFailure extends BillsState {
  final String message;
  const BillsActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
