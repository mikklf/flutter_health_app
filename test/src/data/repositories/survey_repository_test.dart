import 'package:flutter_health_app/domain/interfaces/survey_entry_provider.dart';
import 'package:flutter_health_app/domain/interfaces/survey_provider.dart';
import 'package:flutter_health_app/domain/surveys/surveys.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_health_app/src/data/repositories/survey_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyProvider extends Mock implements ISurveyProvider {}

class MockSurveyEntryProvider extends Mock implements ISurveyEntryProvider {}

void main() {
  late MockSurveyProvider mockSurveyProvider;
  late MockSurveyEntryProvider mockSurveyEntryProvider;
  late SurveyRepository surveyRepository;

  late List<RPSurvey> surveys;

  setUp(() {
    mockSurveyProvider = MockSurveyProvider();
    mockSurveyEntryProvider = MockSurveyEntryProvider();
    surveyRepository =
        SurveyRepository(mockSurveyProvider, mockSurveyEntryProvider);

    surveys = [];
    surveys.add(Surveys.who5);
    surveys.add(Surveys.kellner);
  });

  group('SurveyRepository', () {
    test("GetActive should only return surveys with older entries", () async {
      // Arrange
      List<SurveyEntry> entries = [];

      entries.add(SurveyEntry(
          surveyId: "kellner",
          date: DateTime.now(),
          result: RPTaskResult(identifier: "kellner")));

      entries.add(SurveyEntry(
          surveyId: "who5",
          date: DateTime.now().subtract(const Duration(days: 9)),
          result: RPTaskResult(identifier: "who5")));

      when(() => mockSurveyProvider.getAll()).thenAnswer((_) async => surveys);
      when(() => mockSurveyEntryProvider.getLastEntryOfType("kellner"))
          .thenAnswer((_) async => entries[0].toMap());
      when(() => mockSurveyEntryProvider.getLastEntryOfType("who5"))
          .thenAnswer((_) async => entries[1].toMap());

      // Act
      final result = await surveyRepository.getActive();

      // Assert
      expect(result.length, 1);
      expect(result, contains(surveys[0]));
    });

    test("GetActive should include surveys with no entries", () async {
      // Arrange
      List<SurveyEntry> entries = [];
      entries.add(SurveyEntry(
          surveyId: "kellner",
          date: DateTime.now(),
          result: RPTaskResult(identifier: "kellner")));

      when(() => mockSurveyProvider.getAll()).thenAnswer((_) async => surveys);
      when(() => mockSurveyEntryProvider.getLastEntryOfType("kellner"))
          .thenAnswer((_) async => entries[0].toMap());
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
      List<SurveyEntry> entries = [];

      entries.add(SurveyEntry(
          surveyId: "kellner",
          date: DateTime.now().subtract(const Duration(days: 12)),
          result: RPTaskResult(identifier: "kellner")));

      entries.add(SurveyEntry(
          surveyId: "who5",
          date: DateTime.now().subtract(const Duration(days: 9)),
          result: RPTaskResult(identifier: "who5")));

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
