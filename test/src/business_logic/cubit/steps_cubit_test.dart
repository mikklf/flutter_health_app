import 'package:flutter_health_app/src/logic/cubit/steps_cubit.dart';
import 'package:flutter_health_app/src/data/models/steps.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStepRepository extends Mock implements IStepRepository {}

void main() {
  late MockStepRepository mockStepRepository;
  late StepsCubit stepsCubit;

  setUp(() {
    mockStepRepository = MockStepRepository();
    stepsCubit = StepsCubit(mockStepRepository);
  });

  tearDown(() {
    stepsCubit.close();
  });

  group("StepsCubit", () {
    test('initial state is StepsInitial', () {
      expect(stepsCubit.state, const StepsCubitState());
      expect(stepsCubit.state.stepsList, []);
    });

    test('getLastestSteps returns steps for last 7 days', () async {
      // arrange
      var mockedData = [
        Steps(
            steps: 100, date: DateTime.now().subtract(const Duration(days: 6))),
        Steps(
            steps: 200, date: DateTime.now().subtract(const Duration(days: 4))),
        Steps(
            steps: 150, date: DateTime.now().subtract(const Duration(days: 2))),
      ];

      when(() => mockStepRepository.getStepsInRange(any(), any()))
          .thenAnswer((_) async => mockedData);

      // act
      await stepsCubit.getLastestSteps();

      // assert
      expect(stepsCubit.state.stepsList.length, 7);
      expect(stepsCubit.state.stepsList[0].steps, 100);
      expect(stepsCubit.state.stepsList[1].steps, 0);
      expect(stepsCubit.state.stepsList[2].steps, 200);
      expect(stepsCubit.state.stepsList[3].steps, 0);
      expect(stepsCubit.state.stepsList[4].steps, 150);
      expect(stepsCubit.state.stepsList[5].steps, 0);
      expect(stepsCubit.state.stepsList[6].steps, 0);
    });
  });
}
