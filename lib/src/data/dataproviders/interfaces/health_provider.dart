import 'package:health/health.dart';

/// Responsible for fetching health related data from the device.
abstract interface class IHealthProvider {
  /// Requests the user for permission to access health data.
  /// Returns true if the user granted permission, false otherwise.
  Future<bool> requestAuthorization();

  /// Returns the total number of steps taken between [startTime] and [endTime].
  /// Returns 0 if no steps are found.
  Future<int> getSteps(DateTime startTime, DateTime endTime);

  /// Returns a list of [HealthDataPoint] containing the heart rates between the given start and end time.
  /// Returns empty list if no entries are found.
  Future<List<HealthDataPoint>> getHeartbeats(DateTime startTime, DateTime endTime);
}
