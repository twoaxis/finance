part of 'assets_bloc.dart';

abstract class AssetsState extends Equatable {
  const AssetsState();
  @override
  List<Object?> get props => [];
}

class AssetsInitial extends AssetsState {
  const AssetsInitial();
}
class AssetsActionPending extends AssetsState {
  const AssetsActionPending();
}
class AssetsActionSuccess extends AssetsState {
  const AssetsActionSuccess();
}
class AssetsActionFailure extends AssetsState {
  final String message;
  const AssetsActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
