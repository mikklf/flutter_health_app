import 'package:flutter_health_app/src/business_logic/cubit/survey_manager_cubit.dart';
import 'package:flutter_health_app/src/data/dataproviders/survey_entry_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_health_app/src/data/repositories/survey_entry_repository.dart';
import 'package:research_package/research_package.dart';

void main() {
  test('survey manager cubit ...', () async {
      final SurveyEntryRepository surveyEntryRepository =
          SurveyEntryRepository(SurveyEntryProvider());

      final SurveyManagerCubit surveyManagerCubit =
          SurveyManagerCubit(surveyEntryRepository);

      await surveyManagerCubit.saveEntry(
          RPTaskResult(identifier: "test_survey"), "test_survey");

      expect(surveyManagerCubit.state, SurveyManagerInitial());
    });
  }