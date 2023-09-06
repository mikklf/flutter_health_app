import 'package:research_package/research_package.dart';

enum SurveyFrequency { anytime, daily, weekly, biWeekly, monthly }

class Survey {

  final String id;
  final String title;
  final String description;
  final SurveyFrequency frequency;

  final RPOrderedTask task;

  Survey(this.id, this.title, this.description, this.frequency, this.task);

}