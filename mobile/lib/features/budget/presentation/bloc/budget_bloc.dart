import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/budget/domain/entities/budget.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final UserRepository _userRepository;

  BudgetBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(BudgetInitial()) {
    on<UpdateBudgetEvent>(_onUpdateBudget);
  }

  Future<void> _onUpdateBudget(UpdateBudgetEvent event, Emitter<BudgetState> emit) async {
    emit(BudgetActionPending());
    try {
      await _userRepository.updateBudget(event.budget);
      emit(BudgetActionSuccess());
    } catch (e) {
      emit(BudgetActionFailure(e.toString()));
    }
  }
}
