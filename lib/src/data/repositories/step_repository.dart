import 'package:flutter_health_app/domain/interfaces/step_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/helpers/health_helper.dart';

import '../models/steps.dart';

class StepRepository {
  final IStepProvider _stepProvider;

  StepRepository(this._stepProvider);

  // TODO: Delete this method, when done implementing Steps widget
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

  Future<void> syncSteps(DateTime startDate) async {
    // Count number of days since startDate
    var daysSinceStart = DateTime.now().difference(startDate).inDays;

    // Get steps for each day
    for (var i = 0; i <= daysSinceStart; i++) {
      var date = startDate.add(Duration(days: i));

      // Set date variable to start of day and calculate end of day
      date = DateTime(date.year, date.month, date.day, 0, 0, 0);
      var midnight = DateTime(date.year, date.month, date.day, 23, 59, 59);

      // Get steps from the Health package
      var steps = await HealthHelper.getSteps(date, midnight);

      // If zero steps, skip
      if (steps == 0) continue;

      await updateStepsForDay(date, steps);
    }

  }
}
