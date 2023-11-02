import 'package:flutter_health_app/survey_objects/surveys.dart';

/// Responsible for fetching [RPSurvey] objects from a data source.
abstract interface class ISurveyProvider {
  /// Returns the [RPSurvey] with the given id.
  /// Throws a [StateError] if no survey with the given id exists.
  Future<RPSurvey> getById(String id);

  /// Returns a list of all [RPSurvey].
  Future<List<RPSurvey>> getAll();
}