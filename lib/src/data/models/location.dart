class Location {
  final double latitude;
  final double longitude;
  final bool isHome;
  final DateTime timestamp;
  final int? id;

  const Location(
      {required this.latitude,
      required this.longitude,
      required this.isHome,
      required this.timestamp,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'is_home': isHome ? 1 : 0,
      'timestamp': timestamp.toString(),
      'id': id,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      isHome: map['is_home'] == 1,
      timestamp: DateTime.parse(map['timestamp']),
      id: map['id'] as int?,
    );
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    bool? isHome,
    DateTime? timestamp,
    int? id,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isHome: isHome ?? this.isHome,
      timestamp: timestamp ?? this.timestamp,
      id: id ?? this.id,
    );
  }

}

