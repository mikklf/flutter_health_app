import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_health_app/src/logic/surveys_cubit.dart';
import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyRepository extends Mock implements ISurveyRepository {}

class MockSurveyEntryRepository extends Mock
    implements ISurveyRepository {}

void main() {
  late MockSurveyRepository mockSurveyRepository;
  late SurveysCubit surveysCubit;
  late List<RPSurvey> surveys;

  setUp(() {
    mockSurveyRepository = MockSurveyRepository();
    surveysCubit =
        SurveysCubit(mockSurveyRepository);

    surveys = [];
    surveys.add(Surveys.who5);
    surveys.add(Surveys.kellner);
  });

  tearDown(() {
    surveysCubit.close();
  });

  group('SurveysBloc', () {
    test('initial state has [surveys] set to []', () {
      expect(surveysCubit.state, const SurveysState());
    });

    blocTest<SurveysCubit, SurveysState>(
      'surveys are loaded when LoadSurveys is called',
      build: () {
        when(() => mockSurveyRepository.getActive())
            .thenAnswer((_) async => surveys);

        return surveysCubit;
      },
      act: (cubit) => cubit.loadSurveys(),
      expect: () {
        return [
          const SurveysState(activeSurveys: [], isLoading: true),
          SurveysState(isLoading: false, activeSurveys: surveys)
        ];
      },
    );
  });

  test('Surveys state remains unchanged after saveEntry', () async {
    final result = RPTaskResult(identifier: 'test_survey');
    const surveyId = 'test_survey';

    when(() => mockSurveyRepository.saveEntry(result, surveyId))
        .thenAnswer((_) async {});

    await surveysCubit.saveEntry(result, surveyId);

    expect(surveysCubit.state, const SurveysState());
    verify(() => mockSurveyRepository.saveEntry(result, surveyId)).called(1);
  });
}
