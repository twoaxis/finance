import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/assets/domain/entities/asset.dart';
import 'package:twoaxis_finance/features/user/domain/repositories/user_repository.dart';

part 'assets_event.dart';
part 'assets_state.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  final UserRepository _userRepository;

  AssetsBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AssetsInitial()) {
    on<AddAssetEvent>(_onAddAsset);
    on<RemoveAssetEvent>(_onRemoveAsset);
    on<UpdateAssetsListEvent>(_onUpdateAssetsList);
  }

  Future<void> _onAddAsset(AddAssetEvent event, Emitter<AssetsState> emit) async {
    emit(AssetsActionPending());
    try {
      await _userRepository.addAsset(event.asset);
      emit(AssetsActionSuccess());
    } catch (e) {
      emit(AssetsActionFailure(e.toString()));
    }
  }

  Future<void> _onRemoveAsset(RemoveAssetEvent event, Emitter<AssetsState> emit) async {
    emit(AssetsActionPending());
    try {
      await _userRepository.removeAsset(event.asset);
      emit(AssetsActionSuccess());
    } catch (e) {
      emit(AssetsActionFailure(e.toString()));
    }
  }

  Future<void> _onUpdateAssetsList(UpdateAssetsListEvent event, Emitter<AssetsState> emit) async {
    emit(AssetsActionPending());
    try {
      await _userRepository.updateAssets(event.assetsList);
      emit(AssetsActionSuccess());
    } catch (e) {
      emit(AssetsActionFailure(e.toString()));
    }
  }
}
