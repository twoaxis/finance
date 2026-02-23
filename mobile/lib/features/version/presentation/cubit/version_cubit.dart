import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:twoaxis_finance/features/version/domain/entities/version.dart';

class VersionCubit extends Cubit<Version> {
  VersionCubit() : super(Version.empty()) {
    _load();
  }

  void _load() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    emit(Version(
        version: packageInfo.version, buildNumber: packageInfo.buildNumber));
  }
}
