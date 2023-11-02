import 'package:flutter_health_app/survey_objects/surveys.dart';

abstract interface class ISurveyRepository {
  /// Returns a list of active surveys.
  /// A survey is active if the user should fill it out.
  Future<List<RPSurvey>> getActive();

  /// Returns a list of all surveys.
  Future<List<RPSurvey>> getAll();
}