import 'package:flutter_health_app/src/data/dataproviders/surveys/surveys.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

class TestSurvey implements RPSurvey {
  @override
  String get id => "test_id";

  @override
  String get title => "test_title";

  @override
  String get description => "test_description";

  @override
  Duration get frequency => const Duration(days: 14);
  @override
  RPOrderedTask get task => RPOrderedTask(identifier: "test_task", steps: []);
}

void main() {
  group('Survey Model', () {
    test('returns correct Survey fromRPSurvey method', () {
      // Arrange
      TestSurvey taskExpected = TestSurvey();
      Duration frequencyExpected = const Duration(days: 14);

      // Act
      Survey survey = Survey.fromRPSurvey(taskExpected);

      // Assert
      expect(survey.id, taskExpected.id);
      expect(survey.title, taskExpected.title);
      expect(survey.description, taskExpected.description);
      expect(survey.frequency, frequencyExpected);
      expect(survey.task.identifier, taskExpected.task.identifier);
    });

    test("Equatable test", () {
      // Arrange
      var survey1 = Survey(
          id: "who5",
          title: "Who5_title",
          description: "who5_description",
          frequency: const Duration(days: 5),
          task: RPOrderedTask(identifier: "who5_survey", steps: []));

      var survey2 = Survey(
          id: "who5",
          title: "Who5_title2",
          description: "who5_description2",
          frequency: const Duration(days: 6),
          task: RPOrderedTask(identifier: "who5_survey", steps: []));

      var survey3 = Survey(
          id: "kellner",
          title: "kellner_title",
          description: "kellner_description",
          frequency: const Duration(days: 7),
          task: RPOrderedTask(identifier: "kellner_survey", steps: []));

      // Act
      bool result1 = survey1 == survey2;
      bool result2 = survey1 == survey3;

      // Assert
      expect(result1, true);
      expect(result2, false);
    });
  });
}
