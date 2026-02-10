import 'package:equatable/equatable.dart';

class Bill extends Equatable {
  final String name;
  final double value;

  const Bill({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];

  factory Bill.fromFirestore(Map<String, dynamic> data) {
    return Bill(
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
