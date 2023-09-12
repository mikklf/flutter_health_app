import 'package:flutter_health_app/src/data/dataproviders/surveys/rp_survey.dart';
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
  RPOrderedTask get task => RPOrderedTask(identifier: "test_task", steps: []);
}

void main() {
  group('Survey Model', () {
    test('returns correct Survey fromRPSurvey method', () {
      // Arrange
      TestSurvey taskExpected = TestSurvey();
      Duration frequencyExpected = const Duration(days: 14);

      // Act
      Survey survey = Survey.fromRPSurvey(taskExpected, frequencyExpected);

      // Assert
      expect(survey.id, taskExpected.id);
      expect(survey.title, taskExpected.title);
      expect(survey.description, taskExpected.description);
      expect(survey.frequency, frequencyExpected);
      expect(survey.task.identifier, taskExpected.task.identifier);
    });
  });
}
