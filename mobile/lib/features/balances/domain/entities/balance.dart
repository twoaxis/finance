import 'package:equatable/equatable.dart';

class Balance extends Equatable {
  final String name;
  final double value;

  const Balance({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];

  factory Balance.fromFirestore(Map<String, dynamic> data) {
    return Balance(
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
