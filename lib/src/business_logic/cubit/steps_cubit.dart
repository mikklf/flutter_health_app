import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_health_app/domain/interfaces/step_repository.dart';
import 'package:flutter_health_app/src/data/models/steps.dart';

part 'steps_state.dart';

class StepsCubit extends Cubit<StepsCubitState> {
  final IStepRepository _stepRepository;

  final int _numOfDays = 7;

  StepsCubit(this._stepRepository) : super(const StepsCubitState());

  /// Returns the last [numOfDays] steps entries. Returns 0 on days that have no data.
  Future<void> getLastestSteps() async {
    var startDate = DateTime.now().subtract(Duration(days: _numOfDays - 1));
    var endDate = DateTime.now();

    var stepsData = await _stepRepository.getStepsInRange(startDate, endDate);

    // Sort by earliest date first
    stepsData.sort((a, b) => a.date.compareTo(b.date));

    // Generate a list of all days in the range
    var lastestStepsList = <Steps>[];
    for (var i = 0; i < _numOfDays; i++) {
      lastestStepsList
          .add(Steps(date: startDate.add(Duration(days: i)), steps: 0));
    }

    // Fill in steps count for days that have data
    for (var element in stepsData) {
      // Search for by using date only, neglecting time
      var index = lastestStepsList.indexWhere((x) =>
          x.date.day == element.date.day &&
          x.date.month == element.date.month &&
          x.date.year == element.date.year);

      lastestStepsList[index] = element;
    }

    emit(state.copyWith(stepsList: lastestStepsList));
  }
}
