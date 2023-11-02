abstract interface class ILocationDataContext {
  Future<void> insert(Map<String, Object?> values);
  Future<List<Map<String, dynamic>>> getLocationsForDay(DateTime date);
  Future<Map<String, dynamic>?> getLastest();
}