part of 'liabilities_bloc.dart';

abstract class LiabilitiesEvent extends Equatable {
  const LiabilitiesEvent();
  @override
  List<Object> get props => [];
}

class AddLiabilityEvent extends LiabilitiesEvent {
  final Liability liability;
  const AddLiabilityEvent(this.liability);
  @override
  List<Object> get props => [liability];
}

class RemoveLiabilityEvent extends LiabilitiesEvent {
  final Liability liability;
  const RemoveLiabilityEvent(this.liability);
  @override
  List<Object> get props => [liability];
}

class UpdateLiabilitiesListEvent extends LiabilitiesEvent {
  final List<Liability> liabilitiesList;
  const UpdateLiabilitiesListEvent(this.liabilitiesList);
  @override
  List<Object> get props => [liabilitiesList];
}
