import 'package:flutter_health_app/src/data/data_context/interfaces/weight_datacontext.dart';
import 'package:flutter_health_app/src/data/models/weight.dart';
import 'package:flutter_health_app/src/data/repositories/weight_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeightDataContext extends Mock implements IWeightDataContext {}

void main() {
  late MockWeightDataContext mockWeightContext;
  late WeightRepository weightRepository;

  setUp(() {
    mockWeightContext = MockWeightDataContext();
    weightRepository = WeightRepository(mockWeightContext);
  });

  group('WeightRepository', () {
    test('updateWeight inserts a new weight entry if none exists for the given date', () async {
      final date = DateTime.now();
      const weight = 70.0;

      when(() => mockWeightContext.getWeightsInRange(any(), any())).thenAnswer((_) async => []);
      when(() => mockWeightContext.insert(any())).thenAnswer((_) async => {});

      await weightRepository.updateWeight(date, weight);

      verify(() => mockWeightContext.insert(any())).called(1);
    });

    test('updateWeight updates an existing weight entry for the given date', () async {
      final date = DateTime.now();
      const weight = 70.0;

      final existingWeightEntry = Weight(date: date, weight: 65.0);

      when(() => mockWeightContext.getWeightsInRange(any(), any())).thenAnswer((_) async => [existingWeightEntry.toMap()]);
      when(() => mockWeightContext.update(any())).thenAnswer((_) async => {});

      await weightRepository.updateWeight(date, weight);

      verify(() => mockWeightContext.update(any())).called(1);
    });

    test('getWeightForDay returns null if no weight entry exists for the given date', () async {
      final date = DateTime.now();

      when(() => mockWeightContext.getWeightsInRange(any(), any())).thenAnswer((_) async => []);

      final result = await weightRepository.getWeightForDay(date);

      expect(result, isNull);
    });

    test('getWeightForDay returns the first weight entry for the given date', () async {
      final date = DateTime.now();
      final weightEntry = Weight(date: date, weight: 70.0);

      when(() => mockWeightContext.getWeightsInRange(any(), any())).thenAnswer((_) async => [weightEntry.toMap()]);

      final result = await weightRepository.getWeightForDay(date);

      expect(result?.weight, weightEntry.weight);
      expect(result?.date, weightEntry.date);
    });

    test('getWeightsBetweenDates returns an empty list if no weight entry exists between the given dates', () async {
      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 7));

      when(() => mockWeightContext.getWeightsInRange(any(), any())).thenAnswer((_) async => []);

      final result = await weightRepository.getWeightsBetweenDates(startDate, endDate);

      expect(result, isEmpty);
    });

    test('getWeightsBetweenDates returns all weight entries between the given dates', () async {
      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 7));

      final weightEntry1 = Weight(date: startDate, weight: 70.0);
      final weightEntry2 = Weight(date: startDate.add(const Duration(days: 3)), weight: 72.0);
      final weightEntry3 = Weight(date: endDate, weight: 68.0);

      when(() => mockWeightContext.getWeightsInRange(any(), any())).thenAnswer((_) async => [
        weightEntry1.toMap(),
        weightEntry2.toMap(),
        weightEntry3.toMap(),
      ]);

      final result = await weightRepository.getWeightsBetweenDates(startDate, endDate);

      expect(result[0].weight, weightEntry1.weight);
      expect(result[0].date, weightEntry1.date);
      expect(result[1].weight, weightEntry2.weight);
      expect(result[1].date, weightEntry2.date);
      expect(result[2].weight, weightEntry3.weight);
      expect(result[2].date, weightEntry3.date);
    });

    test('getLatestWeights returns an empty list if no weight entry exists', () async {
      const numOfEntries = 5;

      when(() => mockWeightContext.getLastestWeights(any())).thenAnswer((_) async => []);

      final result = await weightRepository.getLatestWeights(numOfEntries);

      expect(result, isEmpty);
    });

    test('getLatestWeights returns the latest weight entries', () async {
      const numOfEntries = 3;

      final weightEntry1 = Weight(date: DateTime.now().subtract(const Duration(days: 2)), weight: 70.0);
      final weightEntry2 = Weight(date: DateTime.now().subtract(const Duration(days: 1)), weight: 72.0);
      final weightEntry3 = Weight(date: DateTime.now(), weight: 68.0);

      when(() => mockWeightContext.getLastestWeights(any())).thenAnswer((_) async => [
        weightEntry1.toMap(),
        weightEntry2.toMap(),
        weightEntry3.toMap(),
      ]);

      final result = await weightRepository.getLatestWeights(numOfEntries);

      expect(result[0].weight, weightEntry1.weight);
      expect(result[0].date, weightEntry1.date);
      expect(result[1].weight, weightEntry2.weight);
      expect(result[1].date, weightEntry2.date);
      expect(result[2].weight, weightEntry3.weight);
      expect(result[2].date, weightEntry3.date);
    });
  });
}