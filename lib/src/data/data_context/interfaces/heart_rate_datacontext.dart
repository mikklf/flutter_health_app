abstract interface class IHeartRateDataContext {
  /// Returns a list of maps representing heart rates between the given start and end time.
  /// Returns empty list if no entries are found.
  Future<List<Map<String, dynamic>>> getHeartRatesInRange(DateTime startTime, DateTime endTime);

  /// Inserts the given map of values representing a heart rate into the database.
  Future<void> insert(Map<String, Object?> values);
}