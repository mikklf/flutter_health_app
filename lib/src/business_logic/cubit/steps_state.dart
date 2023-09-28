part of 'steps_cubit.dart';

final class StepsCubitState extends Equatable {
  
  final List<Steps> steps;
  final int stepsToday;

  const StepsCubitState({
    this.steps = const [],
    this.stepsToday = 0,
  });

  @override
  List<Object> get props => [steps, stepsToday];

  StepsCubitState copyWith({
    List<Steps>? steps,
    int? stepsToday,
  }) {
    return StepsCubitState(
      steps: steps ?? this.steps,
      stepsToday: stepsToday ?? this.stepsToday,
    );
  }
}