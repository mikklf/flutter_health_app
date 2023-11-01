import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:flutter_health_app/src/data/dataproviders/inmemory_survey_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemorySurveyProvider inMemorySurveyProvider;

  setUp(() {
    inMemorySurveyProvider = InMemorySurveyProvider();
  });

  group('InMemorySurveyProvider', () {
    test('getAll should return all surveys', () async {
      //arrange

      // act
      List<RPSurvey> surveys = await inMemorySurveyProvider.getAll();

      // assert
      expect(surveys, isNotNull);
      expect(surveys.length, 2);
    });

    test('getById should return survey with given id', () async {
      // arrange
      String validId = "kellner";

      // act
      RPSurvey survey = await inMemorySurveyProvider.getById(validId);

      // assert
      expect(survey, isNotNull);
      expect(survey.id, 'kellner');
    });

    test('getById should throw StateError("No element") for invalid id',
        () async {
      // arrange
      String invalidId = "invalidId";

      // act & assert
      expect(() async => await inMemorySurveyProvider.getById(invalidId),
          throwsStateError);
    });
  });
}
