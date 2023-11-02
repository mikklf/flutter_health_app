part of 'steps_cubit.dart';

final class StepsCubitState extends Equatable {
  /// A list of [Steps] objects that contains the steps count for each day.
  final List<Steps> stepsList;

  /// Returns the number of steps for today based on the last element in [stepsList]. Returns 0 if [stepsList] is empty.
  int get stepsToday => stepsList.isEmpty ? 0 : stepsList.last.steps;

  const StepsCubitState({
    this.stepsList = const [],
  });

  @override
  List<Object> get props => [stepsList, stepsToday];

  /// Returns a copy of [StepsCubitState] with the given fields replaced with the new values.
  StepsCubitState copyWith({
    List<Steps>? stepsList,
  }) {
    return StepsCubitState(
      stepsList: stepsList ?? this.stepsList,
    );
  }
}
