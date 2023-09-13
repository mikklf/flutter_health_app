import 'package:research_package/model.dart';

abstract interface class ISurveyEntryRepository {
  Future<void> save(RPTaskResult result, String surveyId);
}