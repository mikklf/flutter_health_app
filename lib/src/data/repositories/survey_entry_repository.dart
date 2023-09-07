import 'package:flutter_health_app/src/data/dataproviders/survey_entry_provider.dart';

import '../models/survery_entry.dart';

class SurveyEntryRepository {
  late final SurveyEntryProvider _entryProvider;

  SurveyEntryRepository() {
    // TODO: Use dependency injection
    _entryProvider = SurveyEntryProvider();
  }

  Future<void> insert(final SurveyEntry newSurvey) async {
    return _entryProvider.insert(newSurvey);
  }

  
}
