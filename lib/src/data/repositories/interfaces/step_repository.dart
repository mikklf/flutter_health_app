import 'package:flutter_health_app/src/data/models/steps.dart';

abstract interface class IStepRepository {
  /// Updates the steps for a given day.
  /// If no steps are found for the given day, a new entry is created.
  Future<void> updateStepsForDay(DateTime date, int steps);

  /// Returns a list of steps between the given start and end time.
  /// Returns an empty list if no steps are found.
  Future<List<Steps>> getStepsInRange(DateTime startDate, DateTime endDate);

  /// Syncs steps from the health provider to the database.
  /// Only syncs steps that are newer than the given start time.
  Future<void> syncSteps(DateTime startDate);
}
