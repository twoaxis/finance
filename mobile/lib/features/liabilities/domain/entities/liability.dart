import 'package:equatable/equatable.dart';

class Liability extends Equatable {
  final String name;
  final double value;

  const Liability({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];

  factory Liability.fromFirestore(Map<String, dynamic> data) {
    return Liability(
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
