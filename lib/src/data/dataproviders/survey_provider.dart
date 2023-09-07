import '../models/survey.dart';

import 'surveys/kellner.dart';
import 'surveys/who5.dart';

class SurveyProvider {

  final List<Survey> _surveylist = [
    Survey.fromRPSurvey(WHO5Survey(), const Duration(days: 14)),
    Survey.fromRPSurvey(KellnerSurvey(), const Duration(minutes: 1)),
  ];

  /// Returns the survey with the given id or [StateError] if no survey with the given id exists.
  Future<Survey> getById(String id) async {
    return _surveylist.firstWhere((element) => element.id == id);
  }

  /// Returns all surveys that the user can start.
  Future<List<Survey>> getActive() async {
    // TODO: Only return surveys that the user can start

    return _surveylist;
  }

  /// Returns all surveys.
  Future<List<Survey>> getAll() async {
    return _surveylist;
  }

}