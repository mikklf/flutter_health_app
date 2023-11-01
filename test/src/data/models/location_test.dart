import 'package:flutter_health_app/src/data/models/location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Location', () {
    test('distanceTo returns correct distance', () {
      final location1 = Location(
        latitude: 12.0,
        longitude: 12.0,
        timestamp: DateTime.now(),
      );
      final location2 = Location(
        latitude: 10.0,
        longitude: 10.0,
        timestamp: DateTime.now(),
      );
      const expectedDistance = 311622.0; // meters

      expect(location1.distanceTo(location2).toInt(), expectedDistance.toInt());
    });

    test('copyWith returns new Location with updated values', () {
      final location1 = Location(
        latitude: 12.432,
        longitude: 10.462,
        timestamp: DateTime(2023, 11, 1),
      );
      final location2 = location1.copyWith(
        latitude: 10.32,
        longitude: 12.23,
        timestamp: DateTime(2023, 11, 2),
      );

      expect(location2.latitude, 10.32);
      expect(location2.longitude, 12.23);
      expect(location2.timestamp, isNot(location1.timestamp));
      expect(location2.id, location1.id);
    });

    test('fromMap returns Location with correct values', () {
      final locationMap = {
        'latitude': 37.7749,
        'longitude': -122.4194,
        'timestamp': DateTime.now().toString(),
        'id': 1,
      };
      final location = Location.fromMap(locationMap);

      expect(location.latitude, 37.7749);
      expect(location.longitude, -122.4194);
      expect(location.timestamp, isA<DateTime>());
      expect(location.id, 1);
    });

    test('toMap returns Map with correct values', () {
      final location = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
        id: 1,
      );
      final locationMap = location.toMap();

      expect(locationMap['latitude'], 37.7749);
      expect(locationMap['longitude'], -122.4194);
      expect(locationMap['timestamp'], isA<String>());
      expect(locationMap['id'], 1);
    });
  });
}