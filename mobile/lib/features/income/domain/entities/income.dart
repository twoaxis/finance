import 'package:equatable/equatable.dart';

class Income extends Equatable {
  final String name;
  final double value;

  const Income({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];

  factory Income.fromFirestore(Map<String, dynamic> data) {
    return Income(
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
