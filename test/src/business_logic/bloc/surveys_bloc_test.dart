import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:flutter_health_app/src/logic/bloc/surveys_bloc.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSurveyRepository extends Mock implements ISurveyRepository {}

void main() {
  late MockSurveyRepository mockSurveyRepository;
  late SurveysBloc surveysBloc;
  late List<RPSurvey> surveys;

  setUp(() {
    mockSurveyRepository = MockSurveyRepository();
    surveysBloc = SurveysBloc(mockSurveyRepository);

    surveys = [];
    surveys.add(Surveys.who5);
    surveys.add(Surveys.kellner);
  });

  tearDown(() {
    surveysBloc.close();
  });

  group('SurveysBloc', () {
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
          const SurveysState(activeSurveys: [], isLoading: true),
          SurveysState(isLoading: false, activeSurveys: surveys)
        ];
      },
    );
  });
}
