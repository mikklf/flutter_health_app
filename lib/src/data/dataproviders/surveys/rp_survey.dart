import 'package:research_package/model.dart';

/// An interface for an survey from the RP package.
abstract class RPSurvey {

  /// The unique identifer of this survey.
  String get id;

  /// The title of this survey.
  String get title;

  /// A short description of this survey
  String get description;

  /// The survey to fill out.
  RPOrderedTask get task;
  
}