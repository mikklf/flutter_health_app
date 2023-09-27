import 'package:flutter_health_app/domain/interfaces/survey_entry_provider.dart';
import 'package:flutter_health_app/domain/interfaces/survey_entry_repository.dart';
import 'package:flutter_health_app/src/data/models/survery_entry.dart';
import 'package:research_package/research_package.dart';

class SurveyEntryRepository implements ISurveyEntryRepository {
  final ISurveyEntryProvider _entryProvider;

  SurveyEntryRepository(this._entryProvider);

  @override
  Future<void> save(RPTaskResult result, String surveyId) async {
    final newSurvey = SurveyEntry(surveyId: surveyId, date: DateTime.now(), result: result);
    return _entryProvider.insert(newSurvey.toMap());
  }
}