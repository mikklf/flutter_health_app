import 'package:flutter_health_app/src/data/dataproviders/surveys/kellner.dart';
import 'package:flutter_health_app/src/data/dataproviders/surveys/who5.dart';
import 'package:research_package/research_package.dart';

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

  /// Returns a instance of a kellner survey
  static RPSurvey get kellner => KellnerSurvey();

  /// Returns a instance of a WHO5 survey
  static RPSurvey get who5 => WHO5Survey();

}