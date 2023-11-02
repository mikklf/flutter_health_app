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
      // Arrange

      // Act
      List<RPSurvey> surveys = await inMemorySurveyProvider.getAll();

      // Assert
      expect(surveys, isNotNull);
      expect(surveys, isNotEmpty);
    });

    test('getById should return survey with given id', () async {
      // Arrange
      String validId = "kellner";

      // Act
      RPSurvey survey = await inMemorySurveyProvider.getById(validId);

      // Assert
      expect(survey, isNotNull);
      expect(survey.id, 'kellner');
    });

    test('getById should throw StateError("No element") for invalid id',
        () async {
      // Arrange
      String invalidId = "invalidId";

      // Act & Assert
      expect(() async => await inMemorySurveyProvider.getById(invalidId),
          throwsStateError);
    });
  });
}
