part of 'survey_manager_cubit.dart';

sealed class SurveyManagerState extends Equatable {
  const SurveyManagerState();

  @override
  List<Object> get props => [];
}

final class SurveyManagerInitial extends SurveyManagerState {}
