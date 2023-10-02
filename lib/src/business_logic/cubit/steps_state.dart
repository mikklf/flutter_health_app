part of 'steps_cubit.dart';

final class StepsCubitState extends Equatable {
  
  final List<Steps> stepsList;
  final int stepsToday;

  const StepsCubitState({
    this.stepsList = const [],
    this.stepsToday = 0,
  });

  @override
  List<Object> get props => [stepsList, stepsToday];

  StepsCubitState copyWith({
    List<Steps>? stepsList,
    int? stepsToday,
  }) {
    return StepsCubitState(
      stepsList: stepsList ?? this.stepsList,
      stepsToday: stepsToday ?? this.stepsToday,
    );
  }
}