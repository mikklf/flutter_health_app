import 'package:flutter_health_app/src/data/repositories/surveys/who5.dart';

import '../models/survery.dart';

enum SurveyEnum { 
  who5
 }

class SurveyRepository {

  Future<Survey> getSurvey(SurveyEnum survey) async {    
    switch (survey) {
      case SurveyEnum.who5:
        return Survey("WHO-5", "WHO-5 Well-being Index", who5);
      default:
        throw Exception("Survey not found");
    }
    
    
  }

  Future<List<Survey>> getActiveSurveys() async {
    return [
      Survey("WHO-5", "WHO-5 Well-being Index", who5),
    ];
  }


}