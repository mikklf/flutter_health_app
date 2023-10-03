import 'package:flutter_health_app/domain/interfaces/survey_entry_provider.dart';
import 'package:flutter_health_app/domain/interfaces/survey_provider.dart';
import 'package:flutter_health_app/domain/interfaces/survey_repository.dart';
import 'package:flutter_health_app/domain/surveys/surveys.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';

class SurveyRepository implements ISurveyRepository {
  final ISurveyProvider _surveyProvider;
  final ISurveyEntryProvider _entryProvider;

  SurveyRepository(this._surveyProvider, this._entryProvider);

  @override
  Future<List<RPSurvey>> getActive() async {
    var surveys = await _surveyProvider.getAll();
    var activeSurveys = <RPSurvey>[];

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
  Future<List<RPSurvey>> getAll() async {
    return _surveyProvider.getAll();
  }
}