import 'package:flutter_health_app/domain/interfaces/survey_entry_provider.dart';
import 'package:flutter_health_app/domain/interfaces/survey_provider.dart';
import 'package:flutter_health_app/domain/interfaces/survey_repository.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';

class SurveyRepository implements ISurveyRepository {
  final ISurveyProvider _surveyProvider;
  final ISurveyEntryProvider _entryProvider;

  SurveyRepository(this._surveyProvider, this._entryProvider);

  @override
  Future<List<Survey>> getActive() async {
    var surveys = await _surveyProvider.getAll();
    var activeSurveys = <Survey>[];

    for (var survey in surveys) {
      var result = await _entryProvider.getLastEntryOfType(survey.id);

      // If no entry exists, the survey has never been answered.
      if (result == null) {
        activeSurveys.add(survey);
        continue;
      }

      var entry = SurveyEntry.fromMap(result);

      DateTime now = DateTime.now();
      DateTime nextTime = entry.date.add(survey.frequency);
      
      if (now.isAfter(nextTime)) {
        activeSurveys.add(survey);
      }
    }

    return activeSurveys;
  }

  @override
  Future<List<Survey>> getAll() async {
    return _surveyProvider.getAll();
  }
}