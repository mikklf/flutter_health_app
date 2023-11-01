import 'package:health/health.dart';

abstract interface class IHealthProvider {
  Future<bool> requestAuthorization();
  Future<int> getSteps(DateTime startTime, DateTime endTime);
  Future<List<HealthDataPoint>> getHeartbeats(DateTime startTime, DateTime endTime);
}
