import 'package:flutter_health_app/src/data/data_context/interfaces/survey_entry_datacontext.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyEntryDataContext extends Mock implements ISurveyEntryDataContext {}

class SurveyEntryFake extends Fake implements SurveyEntry {}

void main() {
  late MockSurveyEntryDataContext mockSurveyEntryContext;
  late SurveyEntryRepository entryRepository;

  setUpAll(() => {
        registerFallbackValue(SurveyEntryFake()),
      });

  setUp(() {
    mockSurveyEntryContext = MockSurveyEntryDataContext();
    entryRepository = SurveyEntryRepository(mockSurveyEntryContext);
  });

  group('SurveyRepository', () {
    test("save method should call EntryProvider save method", () async {
      // Arrange
      var surveyId = "kellner";
      var result = RPTaskResult(identifier: "kellner");

      when(() => mockSurveyEntryContext.insert(any()))
          .thenAnswer((_) async {});

      // Act
      await entryRepository.save(result, surveyId);

      // Assert
      verify(() => mockSurveyEntryContext.insert(any())).called(1);
    });
  });
}
