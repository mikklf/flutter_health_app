import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:research_package/research_package.dart';

class SurveyEntry extends Equatable {
  final int? id;
  final String surveyId;
  final DateTime date;
  final RPTaskResult result;

  const SurveyEntry(this.surveyId, this.date, this.result, [this.id]);

  Map<String, dynamic> toMap() {
    return {
      'survey_id': surveyId,
      'date': date.toString(),
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
  
  @override
  List<Object?> get props => [id];
}
