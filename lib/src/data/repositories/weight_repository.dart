import 'package:flutter_health_app/src/data/models/weight.dart';

import '../data_context/interfaces/weight_datacontext.dart';
import 'interfaces/weight_repository.dart';

class WeightRepository implements IWeightRepository {
  final IWeightDataContext _weightProvider;

  WeightRepository(this._weightProvider);

  /// Inserts or updates the current weight entry for the given date.
  @override
  Future<void> updateWeight(DateTime date, double weight) async {
    var weightEntry = await getWeightForDay(date);

    if (weightEntry == null) {
      await _weightProvider.insert(Weight(date: date, weight: weight).toMap());
      return;
    }

    var updatedEntry = weightEntry.copyWith(weight: weight);
    
    await _weightProvider.update(updatedEntry.toMap());
  }

  /// Gets the first weight entry for the given date.
  @override
  Future<Weight?> getWeightForDay(DateTime date) async {
    var startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    var endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    List<Map<String, dynamic>> maps = await _weightProvider.getWeightsInRange(startOfDay, endOfDay);

    if (maps.isEmpty) return null;

    return Weight.fromMap(maps.first);
  }

  /// Gets all weight entries between the given dates. Returns an empty list if no weight is found
  @override
  Future<List<Weight>> getWeightsBetweenDates(DateTime startDate, DateTime endDate) async {
    var startOfDay = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    var endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    var maps = await _weightProvider.getWeightsInRange(startOfDay, endOfDay);
    return maps.map((e) => Weight.fromMap(e)).toList();
  }

  /// Gets the [numOfEntries] latest weight entries. Returns an empty list if no weight is found
  @override
  Future<List<Weight>> getLatestWeights(int numOfEntries) async {
    var maps = await _weightProvider.getLastestWeights(numOfEntries);
    return maps.map((e) => Weight.fromMap(e)).toList();
  }


}
