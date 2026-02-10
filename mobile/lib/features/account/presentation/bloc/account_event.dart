part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();
  @override
  List<Object> get props => [];
}

class UpdateNameEvent extends AccountEvent {
  final String name;
  const UpdateNameEvent(this.name);
  @override
  List<Object> get props => [name];
}

class UpdateCurrencyEvent extends AccountEvent {
  final String currency;
  const UpdateCurrencyEvent(this.currency);
  @override
  List<Object> get props => [currency];
}
