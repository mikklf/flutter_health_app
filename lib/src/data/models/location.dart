import 'dart:math';

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

  /// Calculates the distance in meters to another [Location]
  double distanceTo(Location location) {
    return _calculateDistance(this, location);
  }

  /// Calculates the distance between two [Location] in meters using the Haversine formula
  double _calculateDistance(Location loc1, Location loc2) {
  // Earth radius in meters
  const radius = 6371e3;

  // Convert degrees to radians for latitude of both locations
  var lat1 = loc1.latitude * pi / 180;
  var lat2 = loc2.latitude * pi / 180;

  // Calculate the difference in latitude and longitude between the two locations in radians
  var deltaLat = (loc2.latitude - loc1.latitude) * pi / 180;
  var deltaLon = (loc2.longitude - loc1.longitude) * pi / 180;

  // Haversine formula: 
  // a is the square of half the chord length between the points
  // c is the angular distance in radians
  var a = sin(deltaLat / 2) * sin(deltaLat / 2) +
      cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
  
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Calculate the distance in meters
  var distance = radius * c;

  return distance;
}

}

