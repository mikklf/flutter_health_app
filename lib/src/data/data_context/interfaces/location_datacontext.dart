abstract interface class ILocationDataContext {
  /// Inserts the given map of values representing a location into the database.
  Future<void> insert(Map<String, Object?> values);

  /// Returns a list of maps representing locations between the given start and end time.
  /// Returns empty list if no entries are found.
  Future<List<Map<String, dynamic>>> getLocationsForDay(DateTime date);

  /// Returns the last entry in the database
  Future<Map<String, dynamic>?> getLastest();
}