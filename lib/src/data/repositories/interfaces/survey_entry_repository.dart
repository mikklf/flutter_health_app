import 'package:research_package/model.dart';

abstract interface class ISurveyEntryRepository {
  /// Saves the [RPTaskResult] to the database using the survey identifer.
  Future<void> save(RPTaskResult result, String surveyId);
}