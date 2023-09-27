abstract interface class IStepProvider {
  Future<int> getSteps(DateTime startTime, DateTime endTime);
  Future<Map<String, dynamic>?> getStepsForDay(DateTime date);
  Future<void> insert(Map<String, Object?> values);
  Future<void> update(Map<String, Object?> values);
}