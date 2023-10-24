abstract interface class IHealthProvider {
  Future<bool> requestAuthorization();
  Future<int> getSteps(DateTime startTime, DateTime endTime);
}
