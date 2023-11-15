import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/survey_provider.dart';

class InMemorySurveyProvider implements ISurveyProvider {
  final List<RPSurvey> _surveylist = [
    Surveys.kellner,

    // Survey for testing purposes
    // Surveys.who5,
    // Surveys.sleepQuality,
  ];

  /// Returns the survey with the given id or [StateError] if no survey with the given id exists.
  @override
  Future<RPSurvey> getById(String id) async {
    return _surveylist.firstWhere((element) => element.id == id);
  }

  /// Returns all surveys.
  @override
  Future<List<RPSurvey>> getAll() async {
    return _surveylist;
  }
}