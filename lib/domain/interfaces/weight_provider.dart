abstract interface class IWeightProvider {
  Future<void> insert(Map<String, Object?> values);
  Future<void> update(Map<String, Object?> values);
  Future<List<Map<String, dynamic>>> getWeightsInRange(
      DateTime startTime, DateTime endTime);
  Future<List<Map<String, dynamic>>> getLastestWeights(int numOfEntries);
}
