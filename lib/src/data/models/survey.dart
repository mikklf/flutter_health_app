import 'package:equatable/equatable.dart';
import 'package:research_package/research_package.dart';
import 'package:flutter_health_app/domain/surveys/surveys.dart';


class Survey extends Equatable {

  final String id;
  final String title;
  final String description;
  final Duration frequency;
  final RPOrderedTask task;

  const Survey({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.task
  });

  Survey.fromRPSurvey(RPSurvey survey)
      : id = survey.id,
        title = survey.title,
        description = survey.description,
        frequency = survey.frequency,
        task = survey.task;
        
  @override
  List<Object?> get props => [id];
 
}