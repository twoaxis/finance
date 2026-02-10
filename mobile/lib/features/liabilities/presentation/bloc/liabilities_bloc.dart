import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/liabilities/domain/entities/liability.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

part 'liabilities_event.dart';
part 'liabilities_state.dart';

class LiabilitiesBloc extends Bloc<LiabilitiesEvent, LiabilitiesState> {
  final UserRepository _userRepository;

  LiabilitiesBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LiabilitiesInitial()) {
    on<AddLiabilityEvent>(_onAddLiability);
    on<RemoveLiabilityEvent>(_onRemoveLiability);
    on<UpdateLiabilitiesListEvent>(_onUpdateLiabilitiesList);
  }

  Future<void> _onAddLiability(AddLiabilityEvent event, Emitter<LiabilitiesState> emit) async {
    emit(LiabilitiesActionPending());
    try {
      await _userRepository.addLiability(event.liability);
      emit(LiabilitiesActionSuccess());
    } catch (e) {
      emit(LiabilitiesActionFailure(e.toString()));
    }
  }

  Future<void> _onRemoveLiability(RemoveLiabilityEvent event, Emitter<LiabilitiesState> emit) async {
    emit(LiabilitiesActionPending());
    try {
      await _userRepository.removeLiability(event.liability);
      emit(LiabilitiesActionSuccess());
    } catch (e) {
      emit(LiabilitiesActionFailure(e.toString()));
    }
  }

  Future<void> _onUpdateLiabilitiesList(UpdateLiabilitiesListEvent event, Emitter<LiabilitiesState> emit) async {
    emit(LiabilitiesActionPending());
    try {
      await _userRepository.updateLiabilities(event.liabilitiesList);
      emit(LiabilitiesActionSuccess());
    } catch (e) {
      emit(LiabilitiesActionFailure(e.toString()));
    }
  }
}
