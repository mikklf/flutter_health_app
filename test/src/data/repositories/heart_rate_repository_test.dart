import 'package:flutter_health_app/src/data/data_context/interfaces/heart_rate_datacontext.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/models/heart_rate.dart';
import 'package:flutter_health_app/src/data/repositories/heart_rate_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

class MockHeartRateProvider extends Mock implements IHeartRateDataContext {}

class MockHealthProvider extends Mock implements IHealthProvider {}

void main() {
  group('HeartRateRepository', () {
    final mockHeartRateProvider = MockHeartRateProvider();
    final mockHealthProvider = MockHealthProvider();
    final heartRateRepository =
        HeartRateRepository(mockHeartRateProvider, mockHealthProvider);

    test('getHeartRatesInRange returns empty list when provider returns null',
        () async {
      // Arrange
      when(() => mockHeartRateProvider.getHeartRatesInRange(any(), any()))
          .thenAnswer((_) async => null);

      // Act
      final result = await heartRateRepository.getHeartRatesInRange(
          DateTime(2021, 1, 1), DateTime(2021, 1, 2));

      // Assert
      expect(result, isEmpty);
    });

    test('getHeartRatesInRange returns list of HeartRate objects', () async {
      // Arrange
      final heartRateMap = {'beats_per_minute': 80, 'timestamp': DateTime.now().toString()};
      when(() => mockHeartRateProvider.getHeartRatesInRange(any(), any())).thenAnswer(
          (_) async => [heartRateMap]);

      // Act
      final result = await heartRateRepository.getHeartRatesInRange(
          DateTime(2021, 1, 1), DateTime(2021, 1, 2));

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.beatsPerMinute, heartRateMap['beats_per_minute']);
      expect(result.first.timestamp, DateTime.parse(heartRateMap['timestamp'].toString()));
    });

    test('insert calls insert on heart rate provider', () async {
      // Arrange
      final heartRate = HeartRate(beatsPerMinute: 80, timestamp: DateTime.now());

      when(() => mockHeartRateProvider.insert(any()))
          .thenAnswer((_) async => {});

      // Act
      await heartRateRepository.insert(heartRate);

      // Assert
      verify(() => mockHeartRateProvider.insert(heartRate.toMap())).called(1);
    });

    test('syncHeartRates does nothing when health provider returns empty list',
        () async {
      // Arrange
      when(() => mockHealthProvider.getHeartbeats(any(), any()))
          .thenAnswer((_) async => []);
      when(() => mockHeartRateProvider.insert(any()))
          .thenAnswer((_) async => {});

      // Act
      await heartRateRepository.syncHeartRates(DateTime(2021, 1, 1));

      // Assert
      verifyNever(() => mockHeartRateProvider.insert(any()));
    });

    test('syncHeartRates inserts HeartRate objects when health provider returns data',
        () async {
      // Arrange
      final healthDataPoint = HealthDataPoint(
          NumericHealthValue(80),
          HealthDataType.HEART_RATE,
          HealthDataUnit.BEATS_PER_MINUTE,
          DateTime(2021, 1, 1),
          DateTime(2021, 1, 1),
          PlatformType.ANDROID,
          'device_id',
          'source_id',
          'source_name');

      when(() => mockHealthProvider.getHeartbeats(any(), any()))
          .thenAnswer((_) async => [healthDataPoint]);
      when(() => mockHeartRateProvider.insert(any()))
          .thenAnswer((_) async => {});

      // Act
      await heartRateRepository.syncHeartRates(DateTime(2021, 1, 1));

      // Assert
      verify(() => mockHeartRateProvider.insert(any())).called(1);
    });
  });
}