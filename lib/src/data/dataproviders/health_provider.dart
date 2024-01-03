import 'package:flutter_health_app/src/data/dataproviders/helpers/health_helper.dart';
import 'package:flutter_health_app/src/data/dataproviders/interfaces/health_provider.dart';
import 'package:health/health.dart';

class HealthProvider implements IHealthProvider {
  // Health data types to be used in the app
  final types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
  ];

  late List<HealthDataAccess> permissions;

  HealthProvider() {
    permissions = types.map((e) => HealthDataAccess.READ).toList();
  }

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

  @override
  Future<int> getSteps(DateTime startTime, DateTime endTime) async {
    final types = [
      HealthDataType.STEPS,
    ];

    final permissions = [
      HealthDataAccess.READ,
    ];

    var health = await _getHealthFactory(types, permissions);

    return await health.getTotalStepsInInterval(startTime, endTime) ?? 0;
  }

  @override
  Future<List<HealthDataPoint>> getHeartbeats(DateTime startTime, DateTime endTime) async {
    final types = [
      HealthDataType.HEART_RATE,
    ];

    final permissions = [
      HealthDataAccess.READ,
    ];

    var health = await _getHealthFactory(types, permissions);

    var data = await health.getHealthDataFromTypes(startTime, endTime, types);

    // Return only unique data points
    return HealthFactory.removeDuplicates(data);
  }


  Future<HealthFactory> _getHealthFactory(List<HealthDataType> types, List<HealthDataAccess> permissions) async {
    var health = await HealthHelper.getHealthFactory();

    bool? isAuthorized = await health.hasPermissions(types, permissions: permissions);

    if (isAuthorized == null || !isAuthorized) {
      bool requested = await health.requestAuthorization(types, permissions: permissions);

      if (!requested) {
        throw Exception("Permission not granted");
      }
    }

    return health;
  }
}
