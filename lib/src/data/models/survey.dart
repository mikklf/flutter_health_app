import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/dataproviders/surveys/rp_survey.dart';
import 'package:research_package/research_package.dart';

class Survey extends Equatable {

  final String id;
  final String title;
  final String description;
  final Duration frequency;
  final RPOrderedTask task;

  const Survey(this.id, this.title, this.description, this.frequency, this.task);

  Survey.fromRPSurvey(RPSurvey survey, this.frequency)
      : id = survey.id,
        title = survey.title,
        description = survey.description,
        task = survey.task;
        
  @override
  List<Object?> get props => [id];
 
}