import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twoaxis_finance/features/auth/domain/auth_repository.dart';
import 'package:twoaxis_finance/features/user/domain/entities/user.dart';
import 'package:twoaxis_finance/features/user/presentation/bloc/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository _authRepository;
  StreamSubscription<User>? _userSubscription;

  UserCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(UserStateInitial()) {
    _init();
  }

  void _init() {
    _userSubscription = _authRepository.user.listen((user) {
      if (user.isNotEmpty) {
        emit(UserStateAuthenticated(user));
      } else {
        emit(UserStateUnauthenticated());
      }
    });
  }

  void updateUser(User user) {
    emit(UserStateAuthenticated(user));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
