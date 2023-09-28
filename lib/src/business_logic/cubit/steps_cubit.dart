import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/src/data/models/steps.dart';
import 'package:flutter_health_app/src/data/repositories/step_repository.dart';

part 'steps_state.dart';

class StepsCubit extends Cubit<StepsCubitState> {
  final StepRepository _stepRepository;

  StepsCubit(this._stepRepository) : super(const StepsCubitState());

  /// Calls the [StepRepository] to get the steps for the current day.
  Future<void> getLastestSteps(int numOfDays) async {
    var steps = await _stepRepository.getStepsInRange(
        DateTime.now().subtract(Duration(days: numOfDays - 1)), DateTime.now());

    steps.sort((a, b) => a.date.compareTo(b.date));

    var stepsToday = 0;
    if (steps.isNotEmpty) {
      stepsToday = steps.last.steps;
    }

    emit(state.copyWith(steps: steps, stepsToday: stepsToday));
  }
}
