abstract interface class IWeatherDataContext {
  /// Inserts the given map of values representing a weather entry into the database.
  Future<void> insert(Map<String, Object?> values);

  /// Returns a map representing the last weather entry.
  /// Returns null if no entry is found.
  Future<Map<String, dynamic>?> getLastest();
}
