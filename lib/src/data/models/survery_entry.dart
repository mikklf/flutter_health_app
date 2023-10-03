import 'dart:convert';
import 'package:research_package/research_package.dart';

class SurveyEntry {
  final String surveyId;
  final DateTime date;
  final RPTaskResult result;
  final int? id;

  const SurveyEntry(
      {required this.surveyId,
      required this.date,
      required this.result,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'survey_id': surveyId,
      'date': date.toString(),
      'result': jsonEncode(result),
    };
  }

  factory SurveyEntry.fromMap(Map<String, dynamic> map) {
    return SurveyEntry(
      surveyId: map['survey_id'] as String,
      date: DateTime.parse(map['date']),
      result: RPTaskResult.fromJson(jsonDecode(map['result'])),
      id: map['id'] as int?
    );
  }
}
