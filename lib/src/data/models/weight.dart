import 'package:equatable/equatable.dart';

class Weight extends Equatable {
  final double weight;
  final DateTime date;
  final int? id;

  const Weight({
    required this.weight,
    required this.date,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'date': date.toString(),
      'id': id,
    };
  }

  factory Weight.fromMap(Map<String, dynamic> map) {
    return Weight(
      weight: map['weight'] as double,
      date: DateTime.parse(map['date']),
      id: map['id'] as int?,
    );
  }
  
  Weight copyWith({
    double? weight,
    DateTime? date,
    int? id,
  }) {
    return Weight(
      weight: weight ?? this.weight,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [id];
}