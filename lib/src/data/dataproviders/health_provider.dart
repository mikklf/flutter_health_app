import 'package:flutter_health_app/domain/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/helpers/health_helper.dart';
import 'package:health/health.dart';

class HealthProvider implements IHealthProvider {
  // Health data types to be used in the app
  final types = [
    HealthDataType.STEPS,
  ];

  final permissions = [
    // Should be only Read permissions
    HealthDataAccess.READ_WRITE,
  ];
  
  /// Requests authorization to read health data from the user.
  /// Returns true if the user granted permission, false otherwise.
  @override
  Future<bool> requestAuthorization() async {
    var health = await HealthHelper.getHealthFactory();

    bool? isAuthorized = await health.hasPermissions(types, permissions: permissions);

    if (isAuthorized == null || !isAuthorized) {
      bool requested = await health.requestAuthorization(types, permissions: permissions);

      if (!requested) {
        return false;
      }
    }

    return true;
  }

  /// Returns the total number of steps taken between [startTime] and [endTime].
  /// If no steps were taken, 0 is returned.
  @override
  Future<int> getSteps(DateTime startTime, DateTime endTime) async {
    final types = [
      HealthDataType.STEPS,
    ];

    final permissions = [
      HealthDataAccess.READ,
    ];

    var health = await HealthHelper.getHealthFactory();

    bool? isAuthorized = await health.hasPermissions(types, permissions: permissions);

    if (isAuthorized == null || !isAuthorized) {
      bool requested = await health.requestAuthorization(types, permissions: permissions);

      if (!requested) {
        throw Exception("Permission not granted");
      }
    }

    return await health.getTotalStepsInInterval(startTime, endTime) ?? 0;
  }
}
