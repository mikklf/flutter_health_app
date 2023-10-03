import 'package:flutter_health_app/domain/interfaces/survey_provider.dart';
import 'package:flutter_health_app/domain/surveys/surveys.dart';

class InMemorySurveyProvider implements ISurveyProvider {
  final List<RPSurvey> _surveylist = [
    Surveys.kellner,
    Surveys.who5,
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