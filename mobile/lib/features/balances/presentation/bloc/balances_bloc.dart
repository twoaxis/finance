import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/balances/domain/entities/balance.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

part 'balances_event.dart';
part 'balances_state.dart';

class BalancesBloc extends Bloc<BalancesEvent, BalancesState> {
  final UserRepository _userRepository;

  BalancesBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(BalancesInitial()) {
    on<AddBalanceEvent>(_onAddBalance);
    on<RemoveBalanceEvent>(_onRemoveBalance);
    on<UpdateBalancesListEvent>(_onUpdateBalancesList);
  }

  Future<void> _onAddBalance(AddBalanceEvent event, Emitter<BalancesState> emit) async {
    emit(BalancesActionPending());
    try {
      await _userRepository.addBalance(event.balance);
      emit(BalancesActionSuccess());
    } catch (e) {
      emit(BalancesActionFailure(e.toString()));
    }
  }

  Future<void> _onRemoveBalance(RemoveBalanceEvent event, Emitter<BalancesState> emit) async {
    emit(BalancesActionPending());
    try {
      await _userRepository.removeBalance(event.balance);
      emit(BalancesActionSuccess());
    } catch (e) {
      emit(BalancesActionFailure(e.toString()));
    }
  }

  Future<void> _onUpdateBalancesList(UpdateBalancesListEvent event, Emitter<BalancesState> emit) async {
    emit(BalancesActionPending());
    try {
      await _userRepository.updateBalances(event.balancesList);
      emit(BalancesActionSuccess());
    } catch (e) {
      emit(BalancesActionFailure(e.toString()));
    }
  }
}
