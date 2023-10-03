import 'package:flutter_health_app/domain/surveys/surveys.dart';

abstract interface class ISurveyRepository {
  Future<List<RPSurvey>> getActive();
  Future<List<RPSurvey>> getAll();
}