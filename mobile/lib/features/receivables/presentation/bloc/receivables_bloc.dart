import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/receivables/domain/entities/receivable.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

part 'receivables_event.dart';
part 'receivables_state.dart';

class ReceivablesBloc extends Bloc<ReceivablesEvent, ReceivablesState> {
  final UserRepository _userRepository;

  ReceivablesBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ReceivablesInitial()) {
    on<AddReceivableEvent>(_onAddReceivable);
    on<RemoveReceivableEvent>(_onRemoveReceivable);
    on<UpdateReceivablesListEvent>(_onUpdateReceivablesList);
  }

  Future<void> _onAddReceivable(AddReceivableEvent event, Emitter<ReceivablesState> emit) async {
    emit(ReceivablesActionPending());
    try {
      await _userRepository.addReceivable(event.receivable);
      emit(ReceivablesActionSuccess());
    } catch (e) {
      emit(ReceivablesActionFailure(e.toString()));
    }
  }

  Future<void> _onRemoveReceivable(RemoveReceivableEvent event, Emitter<ReceivablesState> emit) async {
    emit(ReceivablesActionPending());
    try {
      await _userRepository.removeReceivable(event.receivable);
      emit(ReceivablesActionSuccess());
    } catch (e) {
      emit(ReceivablesActionFailure(e.toString()));
    }
  }

  Future<void> _onUpdateReceivablesList(UpdateReceivablesListEvent event, Emitter<ReceivablesState> emit) async {
    emit(ReceivablesActionPending());
    try {
      await _userRepository.updateReceivables(event.receivablesList);
      emit(ReceivablesActionSuccess());
    } catch (e) {
      emit(ReceivablesActionFailure(e.toString()));
    }
  }
}
