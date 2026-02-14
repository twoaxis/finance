part of 'liabilities_bloc.dart';

abstract class LiabilitiesState extends Equatable {
  const LiabilitiesState();
  @override
  List<Object?> get props => [];
}

class LiabilitiesInitial extends LiabilitiesState {
  const LiabilitiesInitial();
}
class LiabilitiesActionPending extends LiabilitiesState {
  const LiabilitiesActionPending();
}
class LiabilitiesActionSuccess extends LiabilitiesState {
  const LiabilitiesActionSuccess();
}
class LiabilitiesActionFailure extends LiabilitiesState {
  final String message;
  const LiabilitiesActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
