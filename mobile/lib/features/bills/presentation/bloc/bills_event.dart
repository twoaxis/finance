part of 'bills_bloc.dart';

abstract class BillsEvent extends Equatable {
  const BillsEvent();
  @override
  List<Object> get props => [];
}

class AddBillEvent extends BillsEvent {
  final Bill bill;
  const AddBillEvent(this.bill);
  @override
  List<Object> get props => [bill];
}

class RemoveBillEvent extends BillsEvent {
  final Bill bill;
  const RemoveBillEvent(this.bill);
  @override
  List<Object> get props => [bill];
}

class UpdateBillsListEvent extends BillsEvent {
  final List<Bill> billsList;
  const UpdateBillsListEvent(this.billsList);
  @override
  List<Object> get props => [billsList];
}
