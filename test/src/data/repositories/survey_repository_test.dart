import 'package:flutter_health_app/src/data/dataproviders/survey_entry_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/survey_provider.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';
import 'package:flutter_health_app/src/data/repositories/survey_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyProvider extends Mock implements ISurveyProvider {}

class MockSurveyEntryProvider extends Mock implements ISurveyEntryProvider {}

void main() {
  group('SurveyRepository', () {
    late MockSurveyProvider mockSurveyProvider;
    late MockSurveyEntryProvider mockSurveyEntryProvider;
    late SurveyRepository surveyRepository;

    late List<Survey> surveys;

    setUp(() {
      mockSurveyProvider = MockSurveyProvider();
      mockSurveyEntryProvider = MockSurveyEntryProvider();
      surveyRepository =
          SurveyRepository(mockSurveyProvider, mockSurveyEntryProvider);

      surveys = [];
      surveys.add(Survey(
          "who5",
          "who5_title",
          "description1",
          const Duration(days: 7),
          RPOrderedTask(identifier: "who5", steps: [])));
      surveys.add(Survey(
          "kellner",
          "kellner_title",
          "description2",
          const Duration(days: 14),
          RPOrderedTask(identifier: "kellner", steps: [])));
    });

    test("GetActive should only return surveys with older entries", () async {
      // Arrange
      var entries = [];
      entries.add(SurveyEntry(
          "kellner",
          DateTime.now().subtract(const Duration(days: 12)),
          RPTaskResult(identifier: "kellner")));
      entries.add(SurveyEntry(
          "who5",
          DateTime.now().subtract(const Duration(days: 9)),
          RPTaskResult(identifier: "who5")));

      when(() => mockSurveyProvider.getAll()).thenAnswer((_) async => surveys);
      when(() => mockSurveyEntryProvider.getLastEntryOfType("kellner"))
          .thenAnswer((_) async => entries[0]);
      when(() => mockSurveyEntryProvider.getLastEntryOfType("who5"))
          .thenAnswer((_) async => entries[1]);

      // Act
      final result = await surveyRepository.getActive();

      // Assert
      expect(result.length, 1);
      expect(result, contains(surveys[0]));
    });

    test("GetActive should include surveys with no entries", () async {
      // Arrange
      var entries = [];
      entries.add(SurveyEntry(
          "kellner",
          DateTime.now().subtract(const Duration(days: 12)),
          RPTaskResult(identifier: "kellner")));

      when(() => mockSurveyProvider.getAll()).thenAnswer((_) async => surveys);
      when(() => mockSurveyEntryProvider.getLastEntryOfType("kellner"))
          .thenAnswer((_) async => entries[0]);
      when(() => mockSurveyEntryProvider.getLastEntryOfType("who5"))
          .thenAnswer((_) async => null);

      // Act
      final result = await surveyRepository.getActive();

      // Assert
      expect(result.length, 1);
      expect(result, contains(surveys[0]));
    });

    test("GetAll should return all entries", () async {
      // Arrange
      var entries = [];
      entries.add(SurveyEntry(
          "kellner",
          DateTime.now().subtract(const Duration(days: 12)),
          RPTaskResult(identifier: "kellner")));
      entries.add(SurveyEntry(
          "who5",
          DateTime.now().subtract(const Duration(days: 9)),
          RPTaskResult(identifier: "who5")));

      when(() => mockSurveyProvider.getAll()).thenAnswer((_) async => surveys);

      // Act
      final result = await surveyRepository.getAll();

      // Assert
      expect(result.length, 2);
      expect(result, contains(surveys[0]));
      expect(result, contains(surveys[1]));
    });

  });
}
