import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UserRepository _userRepository;

  AccountBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AccountInitial()) {
    on<UpdateNameEvent>(_onUpdateName);
    on<UpdateCurrencyEvent>(_onUpdateCurrency);
  }

  Future<void> _onUpdateName(UpdateNameEvent event, Emitter<AccountState> emit) async {
    emit(AccountActionPending());
    try {
      await _userRepository.updateName(event.name);
      emit(AccountActionSuccess());
    } catch (e) {
      emit(AccountActionFailure(e.toString()));
    }
  }

  Future<void> _onUpdateCurrency(UpdateCurrencyEvent event, Emitter<AccountState> emit) async {
    emit(AccountActionPending());
    try {
      await _userRepository.updateCurrency(event.currency);
      emit(AccountActionSuccess());
    } catch (e) {
      emit(AccountActionFailure(e.toString()));
    }
  }
}
