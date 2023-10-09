class Location {
  final double latitude;
  final double longitude;
  final DateTime date;
  final int? id;

  const Location(
      {required this.latitude,
      required this.longitude,
      required this.date,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'date': date.toString(),
      'id': id,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      date: DateTime.parse(map['date']),
      id: map['id'] as int?,
    );
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    DateTime? date,
    int? id,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }
}
