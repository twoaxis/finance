import 'package:twoaxis_finance/features/user/domain/entities/user.dart';

abstract class UserState {}

class UserStateInitial extends UserState {}

class UserStateAuthenticated extends UserState {
  final User user;

  UserStateAuthenticated(this.user);
}

class UserStateUnauthenticated extends UserState {}
