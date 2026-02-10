import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/income/domain/entities/income.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

part 'income_event.dart';
part 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final UserRepository _userRepository;

  IncomeBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(IncomeInitial()) {
    on<AddIncomeEvent>(_onAddIncome);
    on<RemoveIncomeEvent>(_onRemoveIncome);
    on<UpdateIncomeListEvent>(_onUpdateIncomeList);
  }

  Future<void> _onAddIncome(AddIncomeEvent event, Emitter<IncomeState> emit) async {
    emit(IncomeActionPending());
    try {
      await _userRepository.addIncome(event.income);
      emit(IncomeActionSuccess());
    } catch (e) {
      emit(IncomeActionFailure(e.toString()));
    }
  }

  Future<void> _onRemoveIncome(RemoveIncomeEvent event, Emitter<IncomeState> emit) async {
    emit(IncomeActionPending());
    try {
      await _userRepository.removeIncome(event.income);
      emit(IncomeActionSuccess());
    } catch (e) {
      emit(IncomeActionFailure(e.toString()));
    }
  }

  Future<void> _onUpdateIncomeList(UpdateIncomeListEvent event, Emitter<IncomeState> emit) async {
    emit(IncomeActionPending());
    try {
      await _userRepository.updateIncome(event.incomeList);
      emit(IncomeActionSuccess());
    } catch (e) {
      emit(IncomeActionFailure(e.toString()));
    }
  }
}
