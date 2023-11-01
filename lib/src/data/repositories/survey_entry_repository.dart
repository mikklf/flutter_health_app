import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/survey_entry_repository.dart';
import 'package:research_package/research_package.dart';

import '../data_context/interfaces/survey_entry_datacontext.dart';

class SurveyEntryRepository implements ISurveyEntryRepository {
  final ISurveyEntryDataContext _surveyEntryContext;

  SurveyEntryRepository(this._surveyEntryContext);

  @override
  Future<void> save(RPTaskResult result, String surveyId) async {
    final newSurvey = SurveyEntry(surveyId: surveyId, date: DateTime.now(), result: result);
    return _surveyEntryContext.insert(newSurvey.toMap());
  }
}