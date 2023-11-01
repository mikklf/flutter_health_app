import 'package:flutter_health_app/src/data/models/heart_rate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HeartRate', () {
    test('toMap should return a map with the correct values', () {
      // Arrange
      final heartRate = HeartRate(
        beatsPerMinute: 80,
        timestamp: DateTime(2022, 1, 1),
        id: 1,
      );

      // Act
      final result = heartRate.toMap();

      // Assert
      expect(result['beats_per_minute'], 80);
      expect(result['timestamp'], '2022-01-01 00:00:00.000');
      expect(result['id'], 1);
    });

    test('fromMap should return a HeartRate object with the correct values', () {
      // Arrange
      final map = {
        'beats_per_minute': 80,
        'timestamp': '2022-01-01 00:00:00.000',
        'id': 1,
      };

      // Act
      final result = HeartRate.fromMap(map);

      // Assert
      expect(result.beatsPerMinute, 80);
      expect(result.timestamp, DateTime(2022, 1, 1));
      expect(result.id, 1);
    });

    test('copyWith should return a new HeartRate object with the correct values', () {
      // Arrange
      final heartRate = HeartRate(
        beatsPerMinute: 80,
        timestamp: DateTime(2022, 1, 1),
        id: 1,
      );

      // Act
      final result = heartRate.copyWith(
        beatsPerMinute: 90,
        timestamp: DateTime(2022, 1, 2),
        id: 2,
      );

      // Assert
      expect(result.beatsPerMinute, 90);
      expect(result.timestamp, DateTime(2022, 1, 2));
      expect(result.id, 2);
    });
  });
}