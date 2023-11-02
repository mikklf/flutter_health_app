part of 'surveys_bloc.dart';


class LoadSurveys extends SurveysEvent {}

sealed class SurveysEvent extends Equatable {
  const SurveysEvent();

  @override
  List<Object> get props => [];
}
