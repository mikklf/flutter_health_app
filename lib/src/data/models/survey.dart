import 'package:flutter_health_app/src/data/dataproviders/surveys/rp_survey.dart';
import 'package:research_package/research_package.dart';

enum SurveyFrequency { anytime, daily, weekly, biWeekly, monthly }

class Survey {

  final String id;
  final String title;
  final String description;
  final SurveyFrequency frequency;

  final RPOrderedTask task;

  Survey(this.id, this.title, this.description, this.frequency, this.task);

  Survey.fromRPSurvey(RPSurvey survey, this.frequency)
      : id = survey.id,
        title = survey.title,
        description = survey.description,
        task = survey.task;

}