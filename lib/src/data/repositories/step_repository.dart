import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/models/steps.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/step_repository.dart';

import '../data_context/interfaces/step_datacontext.dart';

class StepRepository implements IStepRepository{
  final IStepDataContext _stepContext;
  final IHealthProvider _healthProvider;

  StepRepository(this._stepContext, this._healthProvider);

  @override
  Future<void> updateStepsForDay(DateTime date, int steps) async {
    // Check if we have steps for this date
    var entry = await _stepContext.getStepsForDay(date);

    if (entry == null) {
      _stepContext.insert(Steps(steps: steps, date: date).toMap());
      return;
    }

    // Update existing entry with new steps
    var updatedEntry = Steps.fromMap(entry).copyWith(steps: steps);

    _stepContext.update(updatedEntry.toMap());
  }

  @override
  Future<List<Steps>> getStepsInRange(
      DateTime startDate, DateTime endDate) async {
    var mapSteps = await _stepContext.getSteps(startDate, endDate);

    return mapSteps.map((e) => Steps.fromMap(e)).toList();
  }

  @override
  Future<void> syncSteps(DateTime startDate) async {
    var daysSinceStart = DateTime.now().difference(startDate).inDays;

    // Get steps for each day since startDate
    for (var i = 0; i <= daysSinceStart; i++) {
      var date = startDate.add(Duration(days: i));

      date = DateTime(date.year, date.month, date.day, 0, 0, 0);
      var midnight = DateTime(date.year, date.month, date.day, 23, 59, 59);

      // Get steps from mobile device
      var steps = await _healthProvider.getSteps(date, midnight);

      if (steps == 0) continue;

      await updateStepsForDay(date, steps);
    }
  }
}
