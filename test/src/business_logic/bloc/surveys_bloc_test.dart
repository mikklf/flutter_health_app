import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_health_app/src/business_logic/bloc/surveys_bloc.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:flutter_health_app/src/data/repositories/survey_repository.dart';
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
      surveys.add(Survey("who5", "who5_title", "description1", Duration.zero,
          RPOrderedTask(identifier: "1", steps: [])));
      surveys.add(Survey("kellner", "kellner_title", "description2",
          Duration.zero, RPOrderedTask(identifier: "1", steps: [])));

       surveysExpected = [];
       surveysExpected.add(Survey("who5", "who5_title", "description1", Duration.zero,
          RPOrderedTask(identifier: "1", steps: [])));
      surveysExpected.add(Survey("kellner", "kellner_title", "description2",
          Duration.zero, RPOrderedTask(identifier: "1", steps: [])));
    });

    tearDown(() {
      surveysBloc.close();
    });

    test('initial state has [surveys] set to []', () {
      expect(surveysBloc.state, const SurveysInitial([]));
    });

    blocTest<SurveysBloc, SurveysState>(
      'surveys are loaded when LoadSurveys is called',
      build: () {
        when(() => mockSurveyRepository.getActive())
            .thenAnswer((_) async => surveys);

        return surveysBloc;
      },
      act: (bloc) => bloc.add(LoadSurveys()),
      expect: () => [SurveysInitial(surveysExpected)],
    );
  });
}
