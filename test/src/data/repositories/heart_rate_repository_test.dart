import 'package:flutter_health_app/src/data/data_context/interfaces/heart_rate_datacontext.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/models/heart_rate.dart';
import 'package:flutter_health_app/src/data/repositories/heart_rate_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

class MockHeartRateDataContext extends Mock implements IHeartRateDataContext {}

class MockHealthProvider extends Mock implements IHealthProvider {}

void main() {
  group('HeartRateRepository', () {
    final mockHeartRateContext = MockHeartRateDataContext();
    final mockHealthProvider = MockHealthProvider();
    final heartRateRepository =
        HeartRateRepository(mockHeartRateContext, mockHealthProvider);

    test('getHeartRatesInRange returns empty list if no data is found',
        () async {
      // Arrange
      when(() => mockHeartRateContext.getHeartRatesInRange(any(), any()))
          .thenAnswer((_) async => []);

      // Act
      final result = await heartRateRepository.getHeartRatesInRange(
          DateTime(2021, 1, 1), DateTime(2021, 1, 2));

      // Assert
      expect(result, isEmpty);
    });

    test('getHeartRatesInRange returns list of HeartRate objects', () async {
      // Arrange
      final heartRateMap = {'beats_per_minute': 80, 'timestamp': DateTime.now().toString()};
      when(() => mockHeartRateContext.getHeartRatesInRange(any(), any())).thenAnswer(
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

      when(() => mockHeartRateContext.insert(any()))
          .thenAnswer((_) async => {});

      // Act
      await heartRateRepository.insert(heartRate);

      // Assert
      verify(() => mockHeartRateContext.insert(heartRate.toMap())).called(1);
    });

    test('syncHeartRates does nothing when health provider returns empty list',
        () async {
      // Arrange
      when(() => mockHealthProvider.getHeartbeats(any(), any()))
          .thenAnswer((_) async => []);
      when(() => mockHeartRateContext.insert(any()))
          .thenAnswer((_) async => {});

      // Act
      await heartRateRepository.syncHeartRates(DateTime(2021, 1, 1));

      // Assert
      verifyNever(() => mockHeartRateContext.insert(any()));
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
      when(() => mockHeartRateContext.insert(any()))
          .thenAnswer((_) async => {});

      // Act
      await heartRateRepository.syncHeartRates(DateTime(2021, 1, 1));

      // Assert
      verify(() => mockHeartRateContext.insert(any())).called(1);
    });
  });
}