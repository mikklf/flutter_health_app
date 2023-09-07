import 'package:flutter_health_app/src/data/dataproviders/survey_entry_provider.dart';
import 'package:research_package/research_package.dart';

import '../models/survery_entry.dart';

class SurveyEntryRepository {
  late final SurveyEntryProvider _entryProvider;

  SurveyEntryRepository() {
    // TODO: Use dependency injection
    _entryProvider = SurveyEntryProvider();
  }

  Future<void> save(RPTaskResult result, String surveyId) async {
    final newSurvey = SurveyEntry(surveyId, DateTime.now(), result);
    return _entryProvider.insert(newSurvey);
  }

  
}