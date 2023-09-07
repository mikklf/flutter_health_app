import '../models/survey.dart';

import 'surveys/kellner.dart';
import 'surveys/who5.dart';

class SurveyProvider {

  final List<Survey> _surveylist = [
    Survey.fromRPSurvey(WHO5Survey(), const Duration(seconds: 15)),
    Survey.fromRPSurvey(KellnerSurvey(), const Duration(minutes: 1)),
  ];

  /// Returns the survey with the given id or [StateError] if no survey with the given id exists.
  Future<Survey> getById(String id) async {
    return _surveylist.firstWhere((element) => element.id == id);
  }

  /// Returns all surveys.
  Future<List<Survey>> getAll() async {
    return _surveylist;
  }

}