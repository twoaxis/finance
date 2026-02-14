part of 'receivables_bloc.dart';

abstract class ReceivablesState extends Equatable {
  const ReceivablesState();
  @override
  List<Object?> get props => [];
}

class ReceivablesInitial extends ReceivablesState {
  const ReceivablesInitial();
}
class ReceivablesActionPending extends ReceivablesState {
  const ReceivablesActionPending();
}
class ReceivablesActionSuccess extends ReceivablesState {
  const ReceivablesActionSuccess();
}
class ReceivablesActionFailure extends ReceivablesState {
  final String message;
  const ReceivablesActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
