import 'package:flutter_health_app/src/data/dataproviders/surveys/surveys.dart';

import '../models/survey.dart';

class SurveyProvider implements ISurveyProvider {

  final List<Survey> _surveylist = [
    Survey.fromRPSurvey(Surveys.kellner),
    Survey.fromRPSurvey(Surveys.who5),
  ];

  /// Returns the survey with the given id or [StateError] if no survey with the given id exists.
  @override
  Future<Survey> getById(String id) async {
    return _surveylist.firstWhere((element) => element.id == id);
  }

  /// Returns all surveys.
  @override
  Future<List<Survey>> getAll() async {
    return _surveylist;
  }

}

abstract class ISurveyProvider {
  Future<Survey> getById(String id);
  Future<List<Survey>> getAll();
}