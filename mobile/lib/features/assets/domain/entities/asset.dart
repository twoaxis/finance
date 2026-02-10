import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final String name;
  final double value;

  const Asset({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];

  factory Asset.fromFirestore(Map<String, dynamic> data) {
    return Asset(
      name: data['name'] as String,
      value: (data['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "value": value,
    };
  }
}
