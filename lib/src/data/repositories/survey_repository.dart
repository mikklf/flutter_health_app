import 'package:research_package/research_package.dart';
import 'package:flutter_health_app/src/data/models/survey.dart';

part 'surveys/who5.dart';
part 'surveys/kellner.dart';

enum SurveyEnum { who5 }

class SurveyRepository {
  final List<Survey> _surveylist = [
    Survey("who5", "WHO-5", "WHO-5 Well-being Index", SurveyFrequency.daily, _who5),
  ];

  Future<Survey> get(SurveyEnum survey) async {
    switch (survey) {
      case SurveyEnum.who5:
        return _surveylist.firstWhere((element) => element.id == "who5");
      default:
        throw Exception("Survey not found");
    }
  }

  Future<List<Survey>> getActive() async {
    // TODO: Remove survey from list that is not active

    return _surveylist;
  }

  Future<List<Survey>> getAll() async {
    return _surveylist;
  }
}
