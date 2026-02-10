import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final double spent;
  final double value;

  const Budget({
    required this.spent,
    required this.value,
  });

  @override
  List<Object?> get props => [spent, value];

  factory Budget.fromFirestore(Map<String, dynamic> data) {
    return Budget(
      spent: (data['spent'] as num).toDouble(),
      value: (data['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "spent": spent,
      "value": value,
    };
  }
}
