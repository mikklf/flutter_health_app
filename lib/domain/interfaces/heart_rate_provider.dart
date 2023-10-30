abstract interface class IHeartRateProvider {
  Future<List<Map<String, dynamic>>?> getHeartRatesInRange(DateTime startTime, DateTime endTime);
  Future<void> insert(Map<String, Object?> values);
}