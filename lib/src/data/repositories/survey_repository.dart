import 'package:flutter_health_app/src/data/dataproviders/survey_provider.dart';

import '../models/survey.dart';

class SurveyRepository {
  late final SurveyProvider _surveyProvider;

  SurveyRepository() {
    // TODO: Use dependency injection
    _surveyProvider = SurveyProvider();
  }

  Future<List<Survey>> getActive() async {
    return _surveyProvider.getActive();
  }

  Future<List<Survey>> getAll() async {
    return _surveyProvider.getAll();
  }
}
