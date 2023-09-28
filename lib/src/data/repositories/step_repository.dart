import 'package:flutter_health_app/domain/interfaces/step_provider.dart';

import '../models/steps.dart';

class StepRepository {
  final IStepProvider _stepProvider;

  StepRepository(this._stepProvider);

  Future<int> getStepsForDay(DateTime date) async {
    var entry = await _stepProvider.getStepsForDay(date);

    if (entry == null) return 0;

    var stepsEntry = Steps.fromMap(entry);

    return stepsEntry.steps;
  }

  Future<void> updateStepsForDay(DateTime date, int steps) async {
    // Check if we have steps for this date
    var entry = await _stepProvider.getStepsForDay(date);

    if (entry == null) {
      _stepProvider.insert(Steps(steps: steps, date: date).toMap());
      return;
    }

    var updatedEntry = Steps.fromMap(entry).copyWith(steps: steps);

    _stepProvider.update(updatedEntry.toMap());
  }

  Future<List<Steps>> getStepsInRange(
      DateTime startDate, DateTime endDate) async {
    var mapSteps = await _stepProvider.getSteps(startDate, endDate);

    if (mapSteps == null) return [];

    return mapSteps.map((e) => Steps.fromMap(e)).toList();
  }
}
