part of 'surveys_bloc.dart';

sealed class SurveysState extends Equatable {
  final List<Survey> surveys;

  const SurveysState(this.surveys);
  
  @override
  List<Object> get props => [surveys];

}

final class SurveysInitial extends SurveysState {
  const SurveysInitial(List<Survey> surveys) : super(surveys);
}

