import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_health_app/domain/interfaces/weight_repository.dart';
import 'package:flutter_health_app/src/business_logic/cubit/weights_cubit.dart';
import 'package:flutter_health_app/src/data/models/weight.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeightRepository extends Mock implements IWeightRepository {}

void main() {
  late IWeightRepository weightRepository;
  late WeightsCubit weightsCubit;

  setUp(() {
    weightRepository = MockWeightRepository();
    weightsCubit = WeightsCubit(weightRepository);
  });

  group('WeightsCubit', () {
    test('initial state is correct', () {
      expect(weightsCubit.state, const WeightsCubitState());
    });

    group('getLatestWeights', () {
      final weightsData = [
        Weight(date: DateTime(2022, 1, 1), weight: 70.0),
        Weight(date: DateTime(2022, 1, 2), weight: 71.0),
        Weight(date: DateTime(2022, 1, 3), weight: 72.0),
      ];

      blocTest(
        'emits updated state with weights data',
        build: () {
          when(() => weightRepository.getLatestWeights(any()))
              .thenAnswer((_) async => weightsData);
          return weightsCubit;
        },
        act: (cubit) => cubit.getLatestWeights(),
        expect: () => [
          WeightsCubitState(weightList: weightsData),
        ],
      );

      blocTest(
        'emits updated state with empty list if no data is found',
        build: () {
          when(() => weightRepository.getLatestWeights(any()))
              .thenAnswer((_) async => []);
          return weightsCubit;
        },
        act: (cubit) => cubit.getLatestWeights(),
        expect: () => [
          const WeightsCubitState(weightList: []),
        ],
      );
    });

    group('updateWeight', () {
      final date = DateTime(2022, 1, 1);
      const weight = 70.0;

      blocTest("calls updateWeight on weightRepository",
          build: () {
            when(() => weightRepository.updateWeight(any(), any()))
                .thenAnswer((_) => Future.value());
            when(() => weightRepository.getLatestWeights(any()))
                .thenAnswer((_) async => []);
            return weightsCubit;
          },
          act: (cubit) => cubit.updateWeight(date, weight),
          verify: (_) {
            verify(() => weightRepository.updateWeight(date, weight)).called(1);
          });
    });
  });
}
