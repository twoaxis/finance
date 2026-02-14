part of 'assets_bloc.dart';

abstract class AssetsEvent extends Equatable {
  const AssetsEvent();
  @override
  List<Object> get props => [];
}

class AddAssetEvent extends AssetsEvent {
  final Asset asset;
  const AddAssetEvent(this.asset);
  @override
  List<Object> get props => [asset];
}

class RemoveAssetEvent extends AssetsEvent {
  final Asset asset;
  const RemoveAssetEvent(this.asset);
  @override
  List<Object> get props => [asset];
}

class UpdateAssetsListEvent extends AssetsEvent {
  final List<Asset> assetsList;
  const UpdateAssetsListEvent(this.assetsList);
  @override
  List<Object> get props => [assetsList];
}
