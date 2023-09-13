import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_health_app/domain/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/business_logic/bloc/surveys_bloc.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/research_package.dart';

class MockSurveyRepository extends Mock implements ISurveyRepository {}

void main() {
  group('SurveysBloc', () {
    late MockSurveyRepository mockSurveyRepository;
    late SurveysBloc surveysBloc;
    late List<Survey> surveys;
    late List<Survey> surveysExpected;

    setUp(() {
      mockSurveyRepository = MockSurveyRepository();
      surveysBloc = SurveysBloc(mockSurveyRepository);

      surveys = [];

      surveys.add(Survey(
          id: "who5",
          title: "who5_title",
          description: "description1",
          frequency: Duration.zero,
          task: RPOrderedTask(identifier: "1", steps: [])));

      surveys.add(Survey(
          id: "kellner",
          title: "kellner_title",
          description: "description2",
          frequency: Duration.zero,
          task: RPOrderedTask(identifier: "1", steps: [])));

      surveysExpected = [];

      surveysExpected.add(Survey(
          id: "who5",
          title: "who5_title",
          description: "description1",
          frequency: Duration.zero,
          task: RPOrderedTask(identifier: "1", steps: [])));

      surveysExpected.add(Survey(
          id: "kellner",
          title: "kellner_title",
          description: "description2",
          frequency: Duration.zero,
          task: RPOrderedTask(identifier: "1", steps: [])));
    });

    tearDown(() {
      surveysBloc.close();
    });

    test('initial state has [surveys] set to []', () {
      expect(surveysBloc.state, const SurveysState());
    });

    blocTest<SurveysBloc, SurveysState>(
      'surveys are loaded when LoadSurveys is called',
      build: () {
        when(() => mockSurveyRepository.getActive())
            .thenAnswer((_) async => surveys);

        return surveysBloc;
      },
      act: (bloc) => bloc.add(LoadSurveys()),
      expect: () {
        return [
          const SurveysState(surveys: [], isLoading: true),
          SurveysState(isLoading: false, surveys: surveysExpected)
        ];
      },
    );
  });
}
