import 'dart:convert';

import 'package:research_package/research_package.dart';

class SurveyEntry {

  int? id;
  String surveyId;
  DateTime? startDate;
  DateTime? endDate;
  Map<String, RPResult> result;

  SurveyEntry.fromRPTaskResult(RPTaskResult result, this.surveyId)
      : startDate = result.startDate,
        endDate = result.endDate,
        result = result.results;

  
    Map<String, dynamic> toMap() {
    return {
      'survey_id': surveyId,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
      'result': jsonEncode(result),
    };
  }
  
}