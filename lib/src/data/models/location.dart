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
  double _calculateDistance(Location location1, Location location2) {
    // Radius of the Earth in kilometers
    const double radius = 6371.0; // km

    // Convert latitude and longitude from degrees to radians
    double lat1 = location1.latitude * (pi / 180.0);
    double lon1 = location1.longitude * (pi / 180.0);
    double lat2 = location2.latitude * (pi / 180.0);
    double lon2 = location2.longitude * (pi / 180.0);

    // Calculate the differences in latitude and longitude
    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    // Haversine formula to calculate the central angle between two points
    double a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);

    // Calculate the arc length along the sphere's surface
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculate the distance in kilometers
    double distanceInKm = radius * c;

    // Convert distance to meters and return
    return distanceInKm * 1000;
  }

}