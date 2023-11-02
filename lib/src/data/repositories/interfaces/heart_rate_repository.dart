import 'package:flutter_health_app/src/data/models/heart_rate.dart';

abstract interface class IHeartRateRepository {
  /// Returns a list of heart rates between the given start and end time.
  /// Returns an empty list if no heart rates are found.
  Future<List<HeartRate>> getHeartRatesInRange(
      DateTime startTime, DateTime endTime);

  /// Inserts the given heart rate into the database.
  Future<void> insert(HeartRate heartRate);

  /// Syncs heart rates from the health provider to the database.
  /// Only syncs heart rates that are newer than the given start time.
  Future<void> syncHeartRates(DateTime startTime);
}
