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
    var startDate = DateTime.now().subtract(Duration(days: numOfDays - 1));
    var endDate = DateTime.now();

    var data = await _stepRepository.getStepsInRange(
        startDate, endDate);

    // Sort by earliest date first
    data.sort((a, b) => a.date.compareTo(b.date));

    // Generate a list of all days in the range
    var lastestStepsList = <Steps>[];
    for (var i = 0; i < numOfDays; i++) {
      lastestStepsList.add(Steps(date: startDate.add(Duration(days: i)), steps: 0));
    }

    // Fill in steps count for days that have data
    for (var element in data) {
      // Search for by using date only, neglecting time
      var index = lastestStepsList.indexWhere((x) =>
          x.date.day == element.date.day &&
          x.date.month == element.date.month &&
          x.date.year == element.date.year);

      lastestStepsList[index] = element;
    }

    emit(state.copyWith(stepsList: lastestStepsList, stepsToday: lastestStepsList.last.steps));
  }
}
