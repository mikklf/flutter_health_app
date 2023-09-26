import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:health/health.dart';

class HealthService {
  Future<HealthFactory> _getHealthFactory() async {
    HealthFactory healthFactory;

    // Due to a bug using Health Connect on Andriod SDK 34+ is not possible
    // to use Health Connect.
    // See https://github.com/cph-cachet/flutter-plugins/issues/800
    // We therefore use Health Connect on Android SDK 33 and below
    // and use soon-to-be-deprecated Google Fit API on SDK 34 and above
    if (Platform.isIOS) {
      healthFactory = HealthFactory();
    } else {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 34) {
        healthFactory = HealthFactory();
      } else {
        healthFactory = HealthFactory(useHealthConnectIfAvailable: true);
      }
    }

    return healthFactory;
  }

  Future<int> getSteps(DateTime startTime, DateTime endTime) async {
    var health = await _getHealthFactory();

    var types = [
      HealthDataType.STEPS,
    ];

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
