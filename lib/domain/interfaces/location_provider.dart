abstract interface class ILocationProvider {
  Future<void> insert(Map<String, Object?> values);
  Future<void> update(Map<String, Object?> values);
  Future<List<Map<String, dynamic>>?> getLocationsForDay(DateTime date);
  Future<Map<String, dynamic>?> getLastest();
}