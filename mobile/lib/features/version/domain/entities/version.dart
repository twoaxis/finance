import 'package:equatable/equatable.dart';

class Version extends Equatable {
  final String version;
  final String buildNumber;

  const Version({required this.version, required this.buildNumber});

  factory Version.empty() {
    return Version(version: "v1.5.0", buildNumber: "2");
  }

  @override
  List<Object?> get props => [version, buildNumber];
}
