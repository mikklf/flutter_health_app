class HeartRate {
  final int beatsPerMinute;
  final DateTime timestamp;
  final int? id;

  const HeartRate(
      {required this.beatsPerMinute,
      required this.timestamp,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'beats_per_minute': beatsPerMinute,
      'timestamp': timestamp.toString(),
      'id': id,
    };
  }

  factory HeartRate.fromMap(Map<String, dynamic> map) {
    return HeartRate(
      beatsPerMinute: map['beats_per_minute'] as int,
      timestamp: DateTime.parse(map['timestamp']),
      id: map['id'] as int?
    );
  }

  HeartRate copyWith({
    int? beatsPerMinute,
    DateTime? timestamp,
    int? id,
  }) {
    return HeartRate(
      beatsPerMinute: beatsPerMinute ?? this.beatsPerMinute,
      timestamp: timestamp ?? this.timestamp,
      id: id ?? this.id,
    );
  }
}
