import 'package:flutter_health_app/src/data/dataproviders/survey_entry_provider.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyEntryProvider extends Mock implements ISurveyEntryProvider {}

class SurveyEntryFake extends Fake implements SurveyEntry {}

void main() {
  group('SurveyRepository', () {
    late MockSurveyEntryProvider mockSurveyEntryProvider;
    late SurveyEntryRepository entryRepository;

    setUpAll(() => {
      registerFallbackValue(SurveyEntryFake()),
    });

    setUp(() {
      mockSurveyEntryProvider = MockSurveyEntryProvider();
      entryRepository = SurveyEntryRepository(mockSurveyEntryProvider);
    });

    test("save method should call EntryProvider save method", () async {
      // Arrange
      var surveyId = "kellner";
      var result = RPTaskResult(identifier: "kellner");

      when(() => mockSurveyEntryProvider.insert(any()))
          .thenAnswer((_) async {});

      // Act
      await entryRepository.save(result, surveyId);

      // Assert
      verify(() => mockSurveyEntryProvider.insert(any())).called(1);
    });

  });
}
