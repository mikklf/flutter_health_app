part of 'surveys_bloc.dart';

final class SurveysState extends Equatable {
  /// Indicates whether the surveys are currently being loaded.
  final bool isLoading;

  /// A list of [Survey] objects that contains the active surveys.
  final List<Survey> activeSurveys;

  const SurveysState({
    this.isLoading = false,
    this.activeSurveys = const [],
  });

  @override
  List<Object> get props => [activeSurveys, isLoading];

  /// Returns a copy of [SurveysState] with the given fields replaced with the new values.
  SurveysState copyWith({
    bool? isLoading,
    List<Survey>? surveys,
  }) {
    return SurveysState(
      isLoading: isLoading ?? this.isLoading,
      activeSurveys: surveys ?? activeSurveys,
    );
  }
}
