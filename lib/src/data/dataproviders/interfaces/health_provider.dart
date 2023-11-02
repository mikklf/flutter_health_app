import 'package:health/health.dart';

/// Responsible for fetching health related data from the device.
abstract interface class IHealthProvider {
  /// Requests the user for permission to access health data.
  Future<bool> requestAuthorization();

  /// Returns the total ammount of steps between the given start and end time.
  Future<int> getSteps(DateTime startTime, DateTime endTime);

  /// Returns a list of [HealthDataPoint] containing the heart rates between the given start and end time.
  /// Returns empty list if no entries are found.
  Future<List<HealthDataPoint>> getHeartbeats(DateTime startTime, DateTime endTime);
}
