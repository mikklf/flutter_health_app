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


    var stepsEntry = Steps.fromMap(entry);

    var updatedEntry = stepsEntry.copyWith(steps: steps).toMap();

    _stepProvider.update(updatedEntry);

  }
}
