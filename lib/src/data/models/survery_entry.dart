import 'dart:convert';

import 'package:research_package/research_package.dart';

class SurveyEntry {
  final int? id;
  final String surveyId;
  final DateTime date;
  final RPTaskResult result;

  SurveyEntry(this.surveyId, this.date, this.result, [this.id]);

  Map<String, dynamic> toMap() {
    return {
      'survey_id': surveyId,
      'date': DateTime.now().toString(),
      'result': jsonEncode(result),
    };
  }

  factory SurveyEntry.fromMap(Map<String, dynamic> map) {
    return SurveyEntry(
      map['survey_id'] as String,
      DateTime.parse(map['date']),
      RPTaskResult.fromJson(jsonDecode(map['result'])),
      map['id'] as int?
    );
  }


  
  

}
