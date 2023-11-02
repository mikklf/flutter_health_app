abstract interface class IStepDataContext {
  Future<List<Map<String, dynamic>>> getSteps(DateTime startTime, DateTime endTime);
  Future<Map<String, dynamic>?> getStepsForDay(DateTime date);
  Future<void> insert(Map<String, Object?> values);
  Future<void> update(Map<String, Object?> values);
}