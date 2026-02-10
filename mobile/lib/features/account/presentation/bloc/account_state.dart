part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();
  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {
  const AccountInitial();
}
class AccountActionPending extends AccountState {
  const AccountActionPending();
}
class AccountActionSuccess extends AccountState {
  const AccountActionSuccess();
}
class AccountActionFailure extends AccountState {
  final String message;
  const AccountActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
