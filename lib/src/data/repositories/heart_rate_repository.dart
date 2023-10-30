import 'package:flutter_health_app/domain/interfaces/health_provider.dart';
import 'package:flutter_health_app/domain/interfaces/heart_rate_provider.dart';
import 'package:flutter_health_app/domain/interfaces/heart_rate_repository.dart';
import 'package:health/health.dart';

import '../models/heart_rate.dart';

class HeartRateRepository implements IHeartRateRepository {
  final IHeartRateProvider _heartbeatProvider;
  final IHealthProvider _healthProvider;

  HeartRateRepository(this._heartbeatProvider, this._healthProvider);

  @override
  Future<List<HeartRate>> getHeartRatesInRange(
      DateTime startTime, DateTime endTime) async {
    var result =
        await _heartbeatProvider.getHeartRatesInRange(startTime, endTime);

    if (result == null) {
      return [];
    }

    return result.map((e) => HeartRate.fromMap(e)).toList();
  }

  @override
  Future<void> insert(HeartRate heartRate) async {
    await _heartbeatProvider.insert(heartRate.toMap());
  }

  @override
  Future<void> syncHeartRates(DateTime startTime) async {
    
    var heartrates = await _healthProvider.getHeartbeats(startTime, DateTime.now());

    if (heartrates.isEmpty) {
      return;
    }

    for (HealthDataPoint heartrate in heartrates) {
      var beatsPerMinute = heartrate.value.toJson()['value'] as int;
      var heartRate = HeartRate(
        beatsPerMinute: beatsPerMinute,
        timestamp: heartrate.dateFrom,
      );

      await insert(heartRate);
    }

  }

  

}


// // fetch health data
//      List<HealthDataPoint> healthData =
//          await health.getHealthDataFromTypes(lastSyncTime, now, [HealthDataType.HEART_RATE]);
