import 'package:flutter_health_app/survey_objects/dummy.dart';
import 'package:flutter_health_app/survey_objects/weekly_sleep_quality.dart';
import 'package:research_package/research_package.dart';

import 'kellner.dart';
import 'who5.dart';

/// Wrapper for an [RPOrderedTask] survey from reseach_package.
abstract class RPSurvey {
  /// The unique identifer of this survey.
  String get id;

  /// The title of this survey.
  String get title;

  /// A short description of this survey
  String get description;

  /// The frequency of this survey.
  Duration get frequency;

  /// The survey to fill out.
  RPOrderedTask get task;
}

/// A class that provides access to all surveys.
class Surveys {
  /// Returns a instance of a [KellnerSurvey]
  static RPSurvey get kellner => KellnerSurvey();

  /// Returns a instance of a [WHO5Survey]
  static RPSurvey get who5 => WHO5Survey();

  /// Returns a instance of a [DummySurvey]
  static RPSurvey get dummy => DummySurvey();

  // Returns a instance of a [WeeklySleepQualitySurvey]
  static RPSurvey get sleepQuality => WeeklySleepQualitySurvey();
}
