import 'package:flutter_health_app/domain/surveys/surveys.dart';

abstract interface class ISurveyProvider {
  Future<RPSurvey> getById(String id);
  Future<List<RPSurvey>> getAll();
}