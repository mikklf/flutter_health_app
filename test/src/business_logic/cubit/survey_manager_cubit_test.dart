import 'package:flutter_health_app/src/business_logic/cubit/survey_manager_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:research_package/model.dart';

class MockSurveyEntryRepository extends Mock implements ISurveyEntryRepository {}

void main() {
  late MockSurveyEntryRepository mockSurveyEntryRepository;
  late SurveyManagerCubit surveyManagerCubit;

  setUp(() {
    mockSurveyEntryRepository = MockSurveyEntryRepository();
    surveyManagerCubit = SurveyManagerCubit(mockSurveyEntryRepository);
  });

  tearDown(() {
    surveyManagerCubit.close();
  });

  group('SurveyManagerCubit', () {
    test('initial state is SurveyManagerInitial', () {
      expect(surveyManagerCubit.state, SurveyManagerInitial());
    });
    test('saveEntry emits SurveyManagerInitial when called', () async {
      final result = RPTaskResult(identifier: 'test_survey');
      const surveyId = 'test_survey';

      when(() => mockSurveyEntryRepository.save(result, surveyId))
          .thenAnswer((_) async {});

      await surveyManagerCubit.saveEntry(result, surveyId);

      expect(surveyManagerCubit.state, SurveyManagerInitial());
      verify(() => mockSurveyEntryRepository.save(result, surveyId)).called(1);
    });
  });
}