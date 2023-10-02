import 'package:flutter_health_app/src/data/models/weight.dart';

abstract interface class IWeightRepository {
  Future<void> updateWeight(DateTime date, double weight);
  Future<Weight?> getWeight(DateTime date);
  Future<List<Weight>> getWeights(DateTime startDate, DateTime endDate);
  Future<List<Weight>> getLatestWeights(int numOfEntries);
}