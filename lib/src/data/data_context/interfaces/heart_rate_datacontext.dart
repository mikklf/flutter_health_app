abstract interface class IHeartRateDataContext {
  Future<List<Map<String, dynamic>>?> getHeartRatesInRange(DateTime startTime, DateTime endTime);
  Future<void> insert(Map<String, Object?> values);
}