abstract interface class IWeatherDataContext {
  Future<void> insert(Map<String, Object?> values);
  Future<Map<String, dynamic>?> getLastest();
}
