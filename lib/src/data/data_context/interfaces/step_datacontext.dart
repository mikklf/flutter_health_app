abstract interface class IStepDataContext {
  /// Returns a list of maps representing steps between the given start and end time.
  Future<List<Map<String, dynamic>>> getSteps(DateTime startTime, DateTime endTime);

  /// Returns a map representing steps for the given day.
  /// Returns null if no steps are found.
  Future<Map<String, dynamic>?> getStepsForDay(DateTime date);

  /// Inserts the given map of values representing a step into the database.
  Future<void> insert(Map<String, Object?> values);

  /// Updates the given map of values representing a step in the database.
  Future<void> update(Map<String, Object?> values);
}