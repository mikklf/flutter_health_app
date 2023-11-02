import 'package:flutter_health_app/src/data/models/weight.dart';

abstract interface class IWeightRepository {
  /// Updates the weight for the given day.
  /// If no weight is found for the given day, a new entry is created.
  Future<void> updateWeight(DateTime date, double weight);

  /// Returns the [Weight] for the given day.
  /// Returns null if no weight is found.
  Future<Weight?> getWeightForDay(DateTime date);

  /// Returns a list of [Weight] between the given start and end date.
  /// Returns an empty list if no weight is found.
  Future<List<Weight>> getWeightsBetweenDates(DateTime startDate, DateTime endDate);

  /// Returns the [numOfEntries] latest weight entries.
  /// Returns an empty list if no weight is found.
  Future<List<Weight>> getLatestWeights(int numOfEntries);
}