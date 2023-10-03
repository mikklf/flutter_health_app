abstract interface class IHealthProvider {
  Future<int> getSteps(DateTime startTime, DateTime endTime);
}
