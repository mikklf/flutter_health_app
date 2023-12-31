import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:flutter_health_app/src/data/data_context/interfaces/survey_entry_datacontext.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/survey_provider.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_health_app/src/data/repositories/survey_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyProvider extends Mock implements ISurveyProvider {}

class MockSurveyEntryDataContext extends Mock
    implements ISurveyEntryDataContext {}

void main() {
  late MockSurveyProvider mockSurveyProvider;
  late MockSurveyEntryDataContext mockSurveyEntryContext;
  late SurveyRepository surveyRepository;

  late List<RPSurvey> surveys;

  setUp(() {
    mockSurveyProvider = MockSurveyProvider();
    mockSurveyEntryContext = MockSurveyEntryDataContext();
    surveyRepository =
        SurveyRepository(mockSurveyProvider, mockSurveyEntryContext);

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
      when(() => mockSurveyEntryContext.getLastEntryOfType("kellner"))
          .thenAnswer((_) async => entries[0].toMap());
      when(() => mockSurveyEntryContext.getLastEntryOfType("who5"))
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
      when(() => mockSurveyEntryContext.getLastEntryOfType("kellner"))
          .thenAnswer((_) async => entries[0].toMap());
      when(() => mockSurveyEntryContext.getLastEntryOfType("who5"))
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

    test("saveEntry method should call EntryProvider save method", () async {
      // Arrange
      var surveyId = "kellner";
      var result = RPTaskResult(identifier: "kellner");

      when(() => mockSurveyEntryContext.insert(any())).thenAnswer((_) async {});

      // Act
      await surveyRepository.saveEntry(result, surveyId);

      // Assert
      verify(() => mockSurveyEntryContext.insert(any())).called(1);
    });
  });
}
