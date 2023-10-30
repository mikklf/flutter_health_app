import 'package:flutter_health_app/src/data/models/heart_rate.dart';

abstract interface class IHeartRateRepository {
  Future<List<HeartRate>> getHeartRatesInRange(
      DateTime startTime, DateTime endTime);
  Future<void> insert(HeartRate heartRate);
  Future<void> syncHeartRates(DateTime startTime);
}
