import 'package:flutter_health_app/domain/interfaces/health_provider.dart';
import 'package:flutter_health_app/src/data/dataproviders/helpers/health_helper.dart';
import 'package:health/health.dart';

class HealthProvider implements IHealthProvider {
  
  @override
  Future<int> getSteps(DateTime startTime, DateTime endTime) async {
    final types = [
      HealthDataType.STEPS,
    ];

    var health = await HealthHelper.getHealthFactory();

    bool? isAuthorized = await health.hasPermissions(types);

    if (isAuthorized == null || !isAuthorized) {
      bool requested = await health.requestAuthorization(types);

      if (!requested) {
        throw Exception("Permission not granted");
      }
    }

    return await health.getTotalStepsInInterval(startTime, endTime) ?? 0;
  }


}