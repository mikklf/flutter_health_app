import 'package:flutter_health_app/src/data/data_context/interfaces/step_datacontext.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/repositories/step_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStepDataContext extends Mock implements IStepDataContext {}

class MockHealthProvider extends Mock implements IHealthProvider {}

void main() {
  late IStepDataContext mockStepContext;
  late IHealthProvider mockHealthProvider;
  late StepRepository stepRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    mockStepContext = MockStepDataContext();
    mockHealthProvider = MockHealthProvider();
    stepRepository = StepRepository(mockStepContext, mockHealthProvider);

    when(() => mockStepContext.update(any()))
        .thenAnswer((_) => Future.value(null));
    when(() => mockStepContext.insert(any()))
        .thenAnswer((_) => Future.value(null));
  });

  group('StepRepository', () {
    test('updateStepsForDay should insert new steps if entry is null',
        () async {
      final date = DateTime.now();
      const steps = 1000;

      when(() => mockStepContext.getStepsForDay(date))
          .thenAnswer((_) => Future.value(null));

      await stepRepository.updateStepsForDay(date, steps);

      verify(() => mockStepContext.insert(any())).called(1);
    });

    test('updateStepsForDay should update steps if entry is not null',
        () async {
      final date = DateTime.now();
      const steps = 1000;

      when(() => mockStepContext.getStepsForDay(date)).thenAnswer(
          (_) => Future.value({'steps': 500, 'date': date.toString()}));

      await stepRepository.updateStepsForDay(date, steps);

      verify(() => mockStepContext.update(any())).called(1);
    });

    test('getStepsInRange should return empty list if no steps are found',
        () async {
      final startDate = DateTime.now();
      final endDate = DateTime.now();

      when(() => mockStepContext.getSteps(startDate, endDate))
          .thenAnswer((_) async => []);

      final result = await stepRepository.getStepsInRange(startDate, endDate);

      expect(result, isEmpty);
    });

    test('getStepsInRange should return list of Steps if steps are found',
        () async {
      final startDate = DateTime.now();
      final endDate = DateTime.now();
      final mapSteps = [
        {'steps': 500, 'date': startDate.toString()},
        {'steps': 1000, 'date': endDate.toString()},
      ];

      when(() => mockStepContext.getSteps(startDate, endDate))
          .thenAnswer((_) => Future.value(mapSteps));

      final result = await stepRepository.getStepsInRange(startDate, endDate);

      expect(result, hasLength(2));
    });

    test('syncSteps should call updateStepsForDay for each day since startDate',
        () async {
      final startDate = DateTime.now().subtract(const Duration(days: 2));
      const steps = 1000;

      when(() => mockStepContext.getStepsForDay(any()))
          .thenAnswer((_) => Future.value(null));
      when(() => mockHealthProvider.getSteps(any(), any()))
          .thenAnswer((_) => Future.value(steps));

      await stepRepository.syncSteps(startDate);

      verify(() => mockStepContext.insert(any())).called(3);
    });
  });
}
