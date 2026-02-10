part of 'receivables_bloc.dart';

abstract class ReceivablesEvent extends Equatable {
  const ReceivablesEvent();
  @override
  List<Object> get props => [];
}

class AddReceivableEvent extends ReceivablesEvent {
  final Receivable receivable;
  const AddReceivableEvent(this.receivable);
  @override
  List<Object> get props => [receivable];
}

class RemoveReceivableEvent extends ReceivablesEvent {
  final Receivable receivable;
  const RemoveReceivableEvent(this.receivable);
  @override
  List<Object> get props => [receivable];
}

class UpdateReceivablesListEvent extends ReceivablesEvent {
  final List<Receivable> receivablesList;
  const UpdateReceivablesListEvent(this.receivablesList);
  @override
  List<Object> get props => [receivablesList];
}
