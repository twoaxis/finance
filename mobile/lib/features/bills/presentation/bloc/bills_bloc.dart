import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/bills/domain/entities/bill.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

part 'bills_event.dart';
part 'bills_state.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  final UserRepository _userRepository;

  BillsBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(BillsInitial()) {
    on<AddBillEvent>(_onAddBill);
    on<RemoveBillEvent>(_onRemoveBill);
    on<UpdateBillsListEvent>(_onUpdateBillsList);
  }

  Future<void> _onAddBill(AddBillEvent event, Emitter<BillsState> emit) async {
    emit(BillsActionPending());
    try {
      await _userRepository.addBill(event.bill);
      emit(BillsActionSuccess());
    } catch (e) {
      emit(BillsActionFailure(e.toString()));
    }
  }

  Future<void> _onRemoveBill(RemoveBillEvent event, Emitter<BillsState> emit) async {
    emit(BillsActionPending());
    try {
      await _userRepository.removeBill(event.bill);
      emit(BillsActionSuccess());
    } catch (e) {
      emit(BillsActionFailure(e.toString()));
    }
  }

  Future<void> _onUpdateBillsList(UpdateBillsListEvent event, Emitter<BillsState> emit) async {
    emit(BillsActionPending());
    try {
      await _userRepository.updateBills(event.billsList);
      emit(BillsActionSuccess());
    } catch (e) {
      emit(BillsActionFailure(e.toString()));
    }
  }
}
