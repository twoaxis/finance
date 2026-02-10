import 'package:equatable/equatable.dart';

class Receivable extends Equatable {
  final String name;
  final double value;

  const Receivable({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];

  factory Receivable.fromFirestore(Map<String, dynamic> data) {
    return Receivable(
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
