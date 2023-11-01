import 'package:flutter_health_app/src/business_logic/cubit/heart_rate_cubit.dart';
import 'package:flutter_health_app/src/data/models/heart_rate.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHeartRateRepository extends Mock implements IHeartRateRepository {}

void main() {
  late MockHeartRateRepository mockHeartRateRepository;
  late HeartRateCubit heartRateCubit;

  setUp(() {
    mockHeartRateRepository = MockHeartRateRepository();
    heartRateCubit = HeartRateCubit(mockHeartRateRepository);
  });

  tearDown(() {
    heartRateCubit.close();
  });

  group('Heart_rate_cubit', () {
    test('initial state is HeartRateState()', () {
      // Assert
      expect(heartRateCubit.state, const HeartRateState());
      expect(heartRateCubit.state.heartRateList.isEmpty, true);
      expect(heartRateCubit.state.highestHeartRate, 0);
      expect(heartRateCubit.state.lowestHeartRate, 0);
    });

    test('emits HeartRateState with rates for the day', () async {
      // Arrange
      final mockData = [
        HeartRate(
            beatsPerMinute: 70,
            timestamp: DateTime.utc(1969, 7, 20, 20, 18, 04))
      ];

      when(() => mockHeartRateRepository.getHeartRatesInRange(any(), any()))
          .thenAnswer((_) async => mockData);

      // Act
      await heartRateCubit.getHeartRatesForDay();

      // Assert
      expect(heartRateCubit.state.heartRateList.length, 1);
      expect(heartRateCubit.state.heartRateList[0].beatsPerMinute, 70);
      expect(heartRateCubit.state.heartRateList[0].timestamp,
          DateTime.utc(1969, 7, 20, 20, 18, 04));
      verify(() => mockHeartRateRepository.getHeartRatesInRange(any(), any()))
          .called(1);
    });
  });
}
