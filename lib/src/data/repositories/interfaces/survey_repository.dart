import 'package:flutter_health_app/survey_objects/surveys.dart';
import 'package:research_package/model.dart';

abstract interface class ISurveyRepository {
  /// Returns a list of active surveys.
  /// A survey is active if the user should fill it out.
  Future<List<RPSurvey>> getActive();

  /// Returns a list of all surveys.
  Future<List<RPSurvey>> getAll();

  /// Saves the [RPTaskResult] to the database using the survey identifer.
  Future<void> saveEntry(RPTaskResult result, String surveyId);
}