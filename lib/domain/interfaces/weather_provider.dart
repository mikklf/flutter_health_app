abstract interface class IWeatherProvider {
  Future<void> insert(Map<String, Object?> values);
  Future<Map<String, dynamic>?> getLastest();
}
