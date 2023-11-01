import 'package:flutter_health_app/survey_objects/surveys.dart';

abstract interface class ISurveyRepository {
  Future<List<RPSurvey>> getActive();
  Future<List<RPSurvey>> getAll();
}