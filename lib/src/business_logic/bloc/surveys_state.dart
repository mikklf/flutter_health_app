part of 'surveys_bloc.dart';

final class SurveysState extends Equatable {
  final bool isLoading;
  final List<Survey> surveys;

  const SurveysState({
    this.isLoading = false,
    this.surveys = const [],
  });
  
  @override
  List<Object> get props => [surveys];

  SurveysState copyWith({
    bool? isLoading,
    List<Survey>? surveys,
  }) {
    return SurveysState(
      isLoading: isLoading ?? this.isLoading,
      surveys: surveys ?? this.surveys,
    );
  }
}
