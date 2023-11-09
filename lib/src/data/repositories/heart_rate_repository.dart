import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/repositories/interfaces/heart_rate_repository.dart';
import 'package:health/health.dart';

import '../data_context/interfaces/heart_rate_datacontext.dart';
import '../models/heart_rate.dart';

class HeartRateRepository implements IHeartRateRepository {
  final IHeartRateDataContext _heartbeatContext;
  final IHealthProvider _healthProvider;

  HeartRateRepository(this._heartbeatContext, this._healthProvider);

  @override
  Future<List<HeartRate>> getHeartRatesInRange(
      DateTime startTime, DateTime endTime) async {
    var result =
        await _heartbeatContext.getHeartRatesInRange(startTime, endTime);

    return result.map((e) => HeartRate.fromMap(e)).toList();
  }

  @override
  Future<void> insert(HeartRate heartRate) async {
    await _heartbeatContext.insert(heartRate.toMap());
  }

  @override
  Future<void> syncHeartRates(DateTime startTime) async {

    if (startTime.isAfter(DateTime.now())) {
      return;
    }

    var heartrates = await _healthProvider.getHeartbeats(startTime, DateTime.now());

    if (heartrates.isEmpty) {
      return;
    }

    for (HealthDataPoint heartrate in heartrates) {
      var value = heartrate.value as NumericHealthValue;

      // Google Fit returns a double, Health Connect returns an int
      // To ensure compatibility, we first try to parse the value as a double
      // Which can handle both cases, and then we convert it to an int which is what we want.
      // No idea what happens on iOS.
      var beatsPerMinuteDouble = double.tryParse(value.numericValue.toString());

      if (beatsPerMinuteDouble == null) {
        continue;
      }

      var beatsPerMinute = beatsPerMinuteDouble.toInt();

      var heartRate = HeartRate(
        beatsPerMinute: beatsPerMinute,
        timestamp: heartrate.dateFrom,
      );

      await insert(heartRate);
    }
  }
}