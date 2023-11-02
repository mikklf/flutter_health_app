abstract interface class IWeightDataContext {
  /// Inserts the given map of values representing a weight entry into the database.
  Future<void> insert(Map<String, Object?> values);

  /// Updates the given map of values representing a weight entry in the database.
  Future<void> update(Map<String, Object?> values);

  /// Returns a list of maps representing weights between the given start and end time.
  /// Returns empty list if no entries are found.
  Future<List<Map<String, dynamic>>> getWeightsInRange(
      DateTime startTime, DateTime endTime);

  /// Returns the a list of map containing the [numOfEntries] most recent weights.
  /// Returns empty list if no entries are found.
  Future<List<Map<String, dynamic>>> getLastestWeights(int numOfEntries);
}
