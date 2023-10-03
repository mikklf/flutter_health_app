class Steps {
  final int steps;
  final DateTime date;
  final int? id;

  const Steps(
      {required this.steps,
      required this.date,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
      'date': date.toString(),
      'id': id,
    };
  }

  factory Steps.fromMap(Map<String, dynamic> map) {
    return Steps(
      steps: map['steps'] as int,
      date: DateTime.parse(map['date']),
      id: map['id'] as int?
    );
  }

  Steps copyWith({
    int? steps,
    DateTime? date,
    int? id,
  }) {
    return Steps(
      steps: steps ?? this.steps,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }
}
