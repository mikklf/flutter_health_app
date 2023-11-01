import 'package:flutter_health_app/survey_objects/surveys.dart';

abstract interface class ISurveyProvider {
  Future<RPSurvey> getById(String id);
  Future<List<RPSurvey>> getAll();
}