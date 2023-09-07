import 'package:flutter_health_app/src/data/dataproviders/survey_provider.dart';

import '../dataproviders/survey_entry_provider.dart';
import '../models/survey.dart';

class SurveyRepository {
  late final SurveyProvider _surveyProvider;
  late final SurveyEntryProvider _entryProvider;

  SurveyRepository() {
    // TODO: Use dependency injection
    _surveyProvider = SurveyProvider();
    _entryProvider = SurveyEntryProvider();
  }

  Future<List<Survey>> getActive() async {
    var surveys = await _surveyProvider.getAll();

    var activeSurveys = <Survey>[];

    for (var survey in surveys) {
      var entry = await _entryProvider.getLastEntryOfType(survey.id);

      if (entry == null) {
        activeSurveys.add(survey);
        continue;
      }

      DateTime now = DateTime.now();

      DateTime nextTime = entry.date.add(survey.frequency);
      
      if (now.isAfter(nextTime)) {
        activeSurveys.add(survey);
      }
    }

    return activeSurveys;
  }

  Future<List<Survey>> getAll() async {
    return _surveyProvider.getAll();
  }
}
